{
		onGenerateInvoice: function() {
			Ext.MessageBox.confirm("Are u sure?", "You want to generate invoice for selected customers.", function(btn){
				if(btn == "yes") {
					var records = this.getSelectionModel().getSelection();
					var record_ids = [];
					Ext.each(records, function(record, index){
						record_ids.push(record.get("id"));
					}, this);
					
					this.generateInvoiceForSelectedCustomers({customer_ids: record_ids}, function(){
						Ext.MessageBox.alert("Status", "Invoices are generated.");
					}, this);
				}
			}, this);	
		},
		onGenerateInvoiceForAll: function() {
			Ext.MessageBox.confirm("Are u sure?", "You want to generate invoice for all customers.", function(btn){
				if(btn == "yes") {
					this.generateInvoiceForAllCustomers({}, function(){
						Ext.MessageBox.alert("Status", "Invoices are generated.");
					}, this);
				}
			}, this);
		},
		onPrint: function(){
			this.getReportUrl({}, function(url){
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
					title : "Customer Information",
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
