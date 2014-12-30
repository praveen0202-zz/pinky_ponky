class CustomerVehiclesList < Nk::Grid

  def configure(c)
    super
    c.model = "CustomerVehicle"
    c.title = "Customer Vehicles"
    c.columns = [
		{name: :customer__name, header: "Cutomer"},
		{name: :vehicle_type__vehicle_name, header: "Vehicle"},
		{name: :vehicle_number, header: "Number"}
    ]
  end
  
  def default_bbar
	[:add_in_form, :edit_in_form, :del]
  end
  
end
