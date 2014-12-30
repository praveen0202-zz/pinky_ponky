module Custom
  class FormPanel < Netzke::Basepack::FormPanel
    include NetzkeBase
    include FormPanelBase
    
    plugin :label_required_plugin    

    def configure_bbar(c)
      c[:bbar] = ["->", :apply.action] if c[:bbar].nil? && !c[:read_only]
    end

    action :apply, text: "", icon: :save_new, tooltip: "Apply"
    action :edit, icon: :edit
    action :cancel, icon: :cancel_new

  end
end
