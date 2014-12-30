class VehicleTypesList < Nk::Grid

  def configure(c)
    super
    c.model = "VehicleType"
    c.title = "Vehicles"
    c.columns = [
		{name: :vehicle_name, header: "Name"}
    ]
  end
  
  def default_bbar
	[:add_in_form, :edit_in_form, :del]
  end
  
end
