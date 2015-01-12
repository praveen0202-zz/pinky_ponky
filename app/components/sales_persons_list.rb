class SalesPersonsList < Nk::Grid

  def configure(c)
    super
    c.model = "SalesPerson"
    c.title = "Sales Persons"
    c.columns = [
			{name: :first_name, label: "First Name"},
			{name: :last_name, label: "Last Name"},
			{name: :phone_number_1, label: "Phone # 1"},
			{name: :phone_number_2, label: "Phone # 2"},
			{name: :address_line1, label: "Adreess Line 1"},
			{name: :address_line2, label: "Adreess Line 2"},
			{name: :email, label: "Email"}
    ]
  end
  
  def default_bbar
		[:add_in_form, :edit_in_form, :del, :print]
  end
 
end
