class CustomerBillForm < Netzke::Basepack::Form

  js_configure do |c|
    c.mixin
  end
  
  def configure(c)
    super
    c.model = "CustomerBill"
    c.title = "Bill"
    c.items = [
        {name: :customer__name, field_label: "Cutomer", itemId: "customer_id"},
		{name: :product__product_name, field_label: "Product", itemId: "product_id"},
		{name: :bill_number, field_label: "Bill #", itemId: "bill_number"},
		{name: :customer_vehicle__vehicle_number, field_label: "Vehicle", itemId: "vehicle_id"},
		{name: :bill_date, field_label: "Date", itemId: "bill_date", format: 'd/m/Y'},
		{name: :product_price__rate, field_label: "Rate", itemId: "rate"},
		{name: :quantity, itemId: "quantity"},
		{name: :bill_amount, field_label: "Amount", itemId: "bill_amount", read_only: true}
    ]
  end
  
  def get_combobox_options_endpoint(params, combo)
	puts "get_combobox_options_endpoint"
	if self.respond_to?("#{params[:attr]}_combobox_options".to_sym)
		self.send("#{params[:attr]}_combobox_options".to_sym, params, combo)
	else
		super
	end
  end
  
  def customer_vehicle__vehicle_number_combobox_options(params, combo)
	data = []
	if component_session[:customer_id]
		customer = Customer.find(component_session[:customer_id])
		cust_vehicles = customer.customer_vehicles
		data = cust_vehicles.collect{|cv| [cv.id, cv.vehicle_number]}
	end
	combo.data = data
  end
  
  def product_price__rate_combobox_options(params, combo)
	data = []
	puts "@@@@@@@@@@@@@@@@@@@@@@"
	puts component_session[:product_id]
	puts component_session[:bill_date]
	if component_session[:product_id] and component_session[:bill_date]  
	    date = component_session[:bill_date][0..9] 
		product_prices = ProductPrice.where(["product_id = ? and effective_from <= ? and (effective_to is null or effective_to >= ?)", component_session[:product_id], date, date])
		data = product_prices.collect{|pp| [pp.id, pp.rate]}
	end
	combo.data = data
  end
  
  endpoint :select_customer_id do |params, me|
	component_session[:customer_id] = params[:customer_id]
  end
  
  endpoint :select_product_id_and_bill_date do |params, me|
	component_session[:product_id] = params[:product_id]
	component_session[:bill_date] = params[:bill_date]
  end

end
