{
		onPrint: function(){
			var invoices = this.getSelectionModel().getSelection();
			var invoice_ids = [];
			Ext.each(invoices, function(invoice, index){
				invoice_ids.push(invoice.get("id"));
			}, this);
			this.getInvoiceReportUrl({invoice_ids: invoice_ids}, function(url){
				this.launchReport(url);
			}, this);
		},
		
		launchReport: function(url){
			var reportUrl = window.location.protocol + "//" + window.location.host + url;
			if (Ext.isGecko) {
				window.location = reportUrl;
			} else {
				Ext.create('Ext.window.Window', {
					width : 800,
					height: 600,
					layout : 'fit',
					title : "Invoice",
					items : [{
						xtype : "component",
						id: 'myIframe',
						autoEl : {
							tag : "iframe",
							href : ""
						}
					}]
				}).show();

				Ext.getDom('myIframe').src = reportUrl;
			}
		}
}
