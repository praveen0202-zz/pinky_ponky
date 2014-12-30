Ext.define('Ext.ux.grid.FilterRow', {
   // extend:'Ext.util.Observable',

    init: function(grid) {
        this.grid = grid;
        this.applyTemplate();
        grid.addClass('filter-row-grid');

        // when Ext grid state restored (untested)
        grid.on("staterestore", this.resetFilterRow, this);

        // when column width programmatically changed
        grid.headerCt.on("columnresize", this.resizeFilterField, this);

        grid.headerCt.on("columnmove", this.resetFilterRow, this);
        grid.headerCt.on("columnshow", this.resetFilterRow, this);
        grid.headerCt.on("columnhide", this.resetFilterRow, this);

        //grid.horizontalScroller.on('bodyscroll', this.scrollFilterField, this);
    },


    applyTemplate: function() {

        var searchItems = [];
        if(this.grid.checkboxModel == true)
            searchItems.push(this.createComponent(Ext.apply(this.addComponentItem(null))));
        this.eachColumn( function(col) {
            if (!col.filterField || col.dataIndex == 'id') {
                if(col.nofilter) {
                    col.filter1 = { };
                } else if(col.addHeaderFilter && !col.filter1 && col.dataIndex != 'id'){
                    col.filter1 = { };
                    col.filter1.xtype = this.getFilterXtype(col.attrType);
                }

                col.filter1 = Ext.apply(this.addComponentItem(col), col.filter1);

                col.filterField = this.createComponent(col.filter1);

            } else {
                if(col.hidden != col.filterField.hidden) {
                    col.filterField.setVisible(!col.hidden);
                }
            }

            if(col.filterField.xtype == 'combo' || col.filterField.xtype == 'datefield') {
                col.filterField.on("change", function(ele){
                    this.onChange();

                    if(ele.lastValue == "right"){
                        ele.removeCls("wrong").removeCls("play").removeCls("no-image");
                        ele.addCls("right1");
                    } else if(ele.lastValue == "wrong"){
                        ele.removeCls("right").removeCls("play").removeCls("no-image");
                        ele.addCls("wrong");
                    } else if(ele.lastValue == "play"){
                        ele.removeCls("wrong").removeCls("right").removeCls("no-image");
                        ele.addCls("play");
                    } else{
                        ele.removeCls("wrong").removeCls("play").removeCls("right");
                        ele.addCls("no-image");
                    }
                }, this);
            } else {
                col.filterField.on("keypress", this.onKeyPress, this);
            }

            if(col.filterField.xtype == 'numberfield'){
                this.numberfieldConfiguration(col);
            }

            searchItems.push(col.filterField);
        });

        if(searchItems.length > 0) {
           this.renderSearchItems(searchItems);
        }
    },

    renderSearchItems: function(items){
        this.grid.addDocked(this.dockedFilter = Ext.create('Ext.container.Container', {
            id:this.grid.id+'docked-filter',
            weight: 100,
            dock: 'top',
            border: '1',
            baseCls: Ext.baseCSSPrefix + 'grid-header-ct',
            items: items,
            layout:{
                type: 'hbox'
            }
        }));
    },

    numberfieldConfiguration: function(col){
        col.filterField.hideTrigger = true;
        col.filterField.keyNavEnabled = false;
        col.filterField.mouseWheelEnabled = false;
    },

    addComponentItem: function(col){
      var hidden = false;
      var width = 23;
      var columnId = "-1"
      if(col != null){
          hidden = col.hidden;
          width = col.width;
          columnId = col.id;
      }
      var filterDivId = this.getFilterDivId(columnId);
      return {
            id:filterDivId,
            hidden:hidden,
            xtype:'component',
            width: width,
            enableKeyEvents:true,
            style:{
                margin:'0px'
            }
        };
    },

    createComponent: function(filter){
        return Ext.ComponentManager.create(filter);
    },

    // Removes filter fields from grid header and recreates
    // template. The latter is needed in case columns have been
    // reordered.
    resetFilterRow: function() {
        this.grid.removeDocked(this.grid.id+'docked-filter', true);
        delete this.dockedFilter;
        this.applyTemplate();
    },

    onChange: function() {
        values = this.constructFilter();
        this.loadGrid(values);
    },

    onKeyPress: function(field, e) {
        if(e.getKey() == e.ENTER) {
            values = this.constructFilter();
            this.loadGrid(values);
        }
    },


    // When grid has forceFit: true, then all columns will be resized
    // when grid resized or column added/removed.
    resizeAllFilterFields: function() {
        //var cm = this.grid.getColumnModel();
        this.eachFilterColumn( function(col, i) {
            if(col.el) { var width = col.getWidth(); }
            else { var width = col.width; }
            this.resizeFilterField(this.grid.headerCt, col, width);
        });
    },

    // Resizes filter field according to the width of column
    resizeFilterField: function(headerCt, column, newColumnWidth) {
        var editor = column.filterField;
        editor.setWidth(newColumnWidth);
    },

    scrollFilterField:function(e, target) {
        var width = this.grid.headerCt.el.dom.firstChild.style.width;
        this.dockedFilter.el.dom.firstChild.style.width = width;
        this.dockedFilter.el.dom.scrollLeft = target.scrollLeft;
    },

    // Returns HTML ID of element containing filter div
    getFilterDivId: function(columnId) {
        return this.grid.id + '-filter-' + columnId;
    },

    // Iterates over each column that has filter
    eachFilterColumn: function(func) {
        this.eachColumn( function(col, i) {
            if (col.filterField) {
                func.call(this, col, i);
            }
        });
    },

    // Iterates over each column in column config array
    eachColumn: function(func) {
        Ext.each(this.grid.columns, func, this);
    },

    constructFilter: function() {
        var values = [];
        this.eachColumn( function(col) {
            if( this.canAddFilterValue(col) ) {
                values.push(this.getFilterQuery(col));
            }
        });
        return values;
    },

    canAddFilterValue: function(col) {
        return (col.filterField && col.filterField.xtype != 'component' && col.filterField.getValue() != '' && col.filterField.getValue() != null);
    },

    getFilterQuery: function(col, op){
        op = op || "eq"
        var fld = {};
        fld['type'] = this.getFilterType(col);
        fld['field'] = col.dataIndex;
        fld['comparison'] = op;
        fld['value'] =  this.getValue(col);
        return fld;
    },

    loadGrid: function(values){
        this.grid.store.load({
            params:{
                filter1:JSON.stringify(values)
            }, filter1: JSON.stringify(values)
        });
    },

    getFilterType: function (col) {
        // map the supported Ext.data.Field type values into a supported filter
        var type = col.filterField.xtype || col.attrType
        switch(type) {
            case 'integer':
            case 'nuberfield':
                type = 'numeric';
                break;
            case 'datetime':
            case 'xdatetime':
                type = 'datetime';
                break;
            case 'date':
            case 'datefield':
                type = 'date';
                break
            case 'string':
            case 'textfield':
            case undefined:
                type = 'string';
                break;
        }
        return type;
    },

    getFilterXtype: function (type) {
        switch(type) {
            case 'integer':
                type = 'numberfield';
                break;
            case 'datetime':
            case 'date':
                type = 'datefield';
                break;
            case 'string':
            case undefined:
                type = 'textfield';
                break;
        }
        return type;
    },

    getValue: function(col){
        var type = col.filterField.xtype || col.attrType;
        var value = col.filterField.getValue();
        switch(type) {
            case 'datetime':
            case 'xdatetime':
            case 'datefield':
            case 'date':
                value = Ext.util.Format.date(value, "m/d/Y");
                break;
        }
        return value;
    }
});
