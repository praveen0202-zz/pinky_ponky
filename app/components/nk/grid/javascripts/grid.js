{
		initComponent: function() {
			/*if(this.plugins) {
				this.plugins.push(new Ext.ux.grid.FilterRow(this));
			} else {
				this.plugins = [new Ext.ux.grid.FilterRow(this)];
			}*/
			
			this.callParent();
			this.on('celldblclick', function( view, td, cellIndex, record, tr, rowIndex, e, eOpts) {
				this.fireEvent('itemdblclick', view, record, e);
				return false;
			});
			this.on('itemdblclick', function(view, record, e){
				this.onEditInForm();
			}, this);
		}
}
