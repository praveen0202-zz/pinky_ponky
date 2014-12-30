{
	afterRender: function() {
		this.callParent();
		
		Ext.each(this.query('netzkeremotecombo'), function(cmp) {
			cmp.store.on('load', function(self, params) {
			  if (cmp.defaultIfSingleItem == undefined || cmp.defaultIfSingleItem == true) {
				var modelName = cmp.parentId + "_" + cmp.name;
				if (self.getCount() == 2 && self.getAt(1).get("field1") == null) {
					this.setValue(self.getAt(0));
					this.fireEvent('select', this);
				}
			  }
			}, cmp);
		});
		this.customerId = this.down("#customer_id");
		this.productId = this.down("#product_id");
		this.vehicleId = this.down("#vehicle_id");
		this.BillDate = this.down("#bill_date");
		this.rate = this.down("#rate");
		this.quantity = this.down("#quantity");
		this.billAmount = this.down("#bill_amount");
		
		this.customerId.on("select", function(ele){
			this.selectCustomerId({customer_id: ele.value}, function(res) {
				this.refreshComboStore(["vehicle_id"]);
			}, this);
		}, this);
		
		this.productId.on("select", function(ele){
			if(ele.value && this.BillDate.value) {
				this.selectProductIdAndBillDate({product_id: ele.value, bill_date: this.BillDate.value}, function(res) {
					this.refreshComboStore(["rate"]);
				}, this);
			}
		}, this);
		
		this.BillDate.on("select", function(ele){
			if(ele.value && this.productId.value) {
				this.selectProductIdAndBillDate({bill_date: ele.value, product_id: this.productId.value}, function(res) {
					this.refreshComboStore(["rate"]);
				}, this);
			}
		}, this);
		
		this.quantity.on("change", function(ele){
			if(ele.value && this.rate.value) {
				this.setBillAmount();
			}
		}, this);
		
		this.rate.on("change", function(ele){
			if(ele.value && this.quantity.value) {
				this.setBillAmount();
			}
		}, this);
	},
	
	setBillAmount: function() {
		var rate = parseFloat(this.rate.rawValue);
		var quantity = parseFloat(this.quantity.value);
		var billAmount = rate * quantity;
		this.billAmount.setValue(billAmount.toFixed(2));
	},
	
	refreshComboStore: function(item_ids) {
		console.log("@@@@");
		item_ids = Ext.isArray(item_ids) ? item_ids : [item_ids]
		Ext.each(item_ids, function(item_id) {
			var cmp = this.query("combo#" + item_id)[0];
			cmp.reset();
			cmp.store.reload({params: {}});
			console.log("Reloading Store of - " + item_id);
		}, this);
	}

}
