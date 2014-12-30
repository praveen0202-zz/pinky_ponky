class CustomerBillsList < Nk::Grid

  def configure(c)
    super
    c.model = "CustomerBill"
    c.title = "Bills"
    c.columns = [
		{name: :customer__name, label: "Cutomer"},
		{name: :product__product_name, label: "Product"},
		{name: :bill_number, label: "Bill #"},
		{name: :customer_vehicle__vehicle_number, label: "Vehicle"},
		{name: :bill_date, label: "Date", format: 'd/m/Y'},
		{name: :product_price__rate, label: "Rate"},
		:quantity,
		{name: :bill_amount, label: "Amount"},
		{name: :status, label: "Status", width: "10%", getter: lambda {|i| i.status.to_s } }
    ]
  end
  
  def default_bbar
	[:add_in_form, :edit_in_form, :del]
  end
  
  def preconfigure_record_window(c)
    super
    c.form_config.klass = CustomerBillForm
  end
  
end
