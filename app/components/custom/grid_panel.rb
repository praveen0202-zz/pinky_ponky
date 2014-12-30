module Custom
  class GridPanel < Netzke::Basepack::GridPanel
    include NetzkeBase
    
    js_method :init_component, <<-JS
    function(){
      this.selectedRecordIds = [];
      if(this.checkboxModel)
        this.selModel = Ext.create('Ext.selection.CheckboxModel');
      this.plugins.push(new Ext.ux.grid.FilterRow(this));
      this.callParent();
      // setting the 'rowclick' event
     if (this.editOnDblClick === undefined || this.editOnDblClick == true) {
      //For associated field columns, somehow celldbclick takes priority, so stubbing it
       this.on('celldblclick', function( view, td, cellIndex, record, tr, rowIndex, e, eOpts) {
          this.fireEvent('itemdblclick', view, record, e);
          return false;
       });
       this.on('itemdblclick', function(view, record, e){
          this.onEditInForm();
        }, this);
     }
      if(this.checkboxModel){
        this.getView().on('refresh', this.refreshSelection, this);
        this.on('select', this.rememberSelection, this);
        this.on('deselect', this.rememberSelection, this);
      }
      this.store.on('beforeload', function(store, operation, eOpts){
        //load method call of store not fetching records properly, So emptying the store, load method fetches all records
        if(this.checkboxModel) this.rememberSelection();
        store.removeAll();
      }, this);
    }
    JS

    def configuration
      super.merge({clear_state_on_destroy: true, emptyText: 'No Records', enable_column_hide: false, infinite_scroll: true})
    end

    def columns(options = {})
      cols = super
      cols.each{|column|
        column[:filterable] = false
        column[:grid_column] = true
      }
      cols
    end

    def get_combobox_options_endpoint(params)
      debug_log "get_combobox_options_endpoint"
      if self.respond_to?("#{params[:column]}_combobox_options".to_sym)
        self.send("#{params[:column]}_combobox_options".to_sym, params)
      else
        super
      end
    end

    def default_fields_for_forms
      selected_columns = columns.select do |c|
        data_class.column_names.include?(c[:name]) ||
            data_class.instance_methods.include?("#{c[:name]}=".to_sym) ||
            association_attr?(c[:name])
      end

      selected_columns.map do |c|
        field_config = {
            :name => c[:name],
            :field_label => c[:text] || c[:header]
        }
        field_config[:scope] = c[:scope]
        field_config[:hidden] = c[:hidden] if c.keys.include?(:hidden)
        field_config[:input_mask] = c[:input_mask] if c.keys.include?(:input_mask)
        # scopes for combobox options
        field_config[:scopes] = c[:editor][:scopes] if c[:editor].is_a?(Hash)

        field_config.merge!(c[:editor] || {})

        field_config
      end
    end

    component :add_form do
      form_config = {
          :class_name => "Mahaswami::FormPanel",
          :model => config[:model],
          :persistent_config => config[:persistent_config],
          :strong_default_attrs => config[:strong_default_attrs],
          :border => true,
          :bbar => false,
          :prevent_header => true,
          :mode => config[:mode],
          :record => data_class.new(columns_default_values)
      }

      # Only provide default form fields when no custom class_name is specified for the form
      form_config[:items] = default_fields_for_forms unless config[:add_form_config] && config[:add_form_config][:class_name]

      {
          :lazy_loading => true,
          :class_name => "Netzke::Basepack::GridPanel::RecordFormWindow",
          :title => "Add #{data_class.model_name.human}",
          :button_align => "right",
          :items => [form_config.deep_merge(config[:add_form_config] || {})]
      }.deep_merge(config[:add_form_window_config] || {})
    end

    component :edit_form do
      form_config = {
          :class_name => "Mahaswami::FormPanel",
          :model => config[:model],
          :persistent_config => config[:persistent_config],
          :bbar => false,
          :prevent_header => true,
          :mode => config[:mode]
          # :record_id gets assigned by deliver_component dynamically, at the moment of loading
      }

      # Only provide default form fields when no custom class_name is specified for the form
      form_config[:items] = default_fields_for_forms unless config[:edit_form_config] && config[:edit_form_config][:class_name]

      {
          :lazy_loading => true,
          :class_name => "Netzke::Basepack::GridPanel::RecordFormWindow",
          :title => "Edit #{data_class.model_name.human}",
          :button_align => "right",
          :items => [form_config.deep_merge(config[:edit_form_config] || {})],
          :record => nil
      }.deep_merge(config[:edit_form_window_config] || {})
    end

    js_method :perform_action, <<-JS
      function(record_id, action) {
        this.triggerEvent({record_id: record_id, action: action});
      }
    JS

    def current_record(record_id)
      self.config[:model].constantize.find(record_id)
    end

    endpoint :trigger_event do |params|
      current_record(params[:record_id]).send("#{params[:action]}!".to_sym)
      {:refresh_data => 1}
    end

    js_method :refresh_data, <<-JS
      function() {
        this.getStore().load();
      }
    JS

    # Extjs42 Fix: Grid get emptied after record deletion. Reference: Latest Netzke Version.
    js_method :load_store_data,<<-JS
      function(data){
        // This code is commented because of buffered render reloading old records.
        //So using store load method fetches new records from server.
        //var dataRecords = this.getStore().getProxy().getReader().read(data);
        //this.getStore().loadData(dataRecords.records);
        //this.store.reload();
        //Ext.each(['data', 'total', 'success'], function(property){delete data[property];}, this);
        //this.bulkExecute(data);
        this.store.load();
      }
    JS

    # TEMPORARY PATCH TO GET THE GRID ROW FILTER FUNCTION. NEED TO REVIEW THIS.
    # Implementation for the "get_data" endpoint
    def get_data(*args)
      params = args.first || {} # params are optional!
      params["limit"] = nil if (params.empty? == false and config[:enable_pagination] == false)
      session_name = (config[:item_id].to_s + "_filter").to_sym
      if (params[:filter1] || component_session[session_name])
        component_session[session_name] = params[:filter1] || component_session[session_name]
        params[:filter] = component_session[session_name]
      end
      if !config[:prohibit_read]
        {}.tap do |res|
          records = get_records(params)
          res[:data] = records.map{|r| r.netzke_array(columns(:with_meta => true))}
          res[:total] = count_records(params) if config[:enable_pagination]
        end
      else
        flash :error => "You don't have permissions to read data"
        { :netzke_feedback => @flash }
      end
    end

    action :del, text:"", tooltip: "Delete", icon: :delete_new
    action :add_in_form, text: "", tool_tip: "Add in form", icon: :add_new
    action :edit_in_form, text: "", tool_tip: "Edit in form", icon: :edit
    action :search, text: "", tool_tip: "Search", icon: :search
    action :edit, text: "", tooltip: "Edit", icon: :edit
    action :apply, tooltip: "Apply", icon: :save_new
=begin
    action :add, icon: false
    action :edit, icon: false
    action :add_in_form, icon: false
    action :edit_in_form, icon: false
    action :del, icon: false
    action :search, icon: false
    action :apply, icon: false
    action :save, icon: false
=end

    # Commented to re-introduce icons manually now for customized actions
    # Regular Actions will take the regular icons by default

  end
end
