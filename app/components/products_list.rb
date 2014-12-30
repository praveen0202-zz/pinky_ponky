class ProductsList < Nk::Grid

  def configure(c)
    super
    c.model = "Product"
    c.columns = [
		{name: :product_name, header: "Name"}
    ]
  end
  
  def default_bbar
	[:add_in_form, :edit_in_form, :del]
  end
  
end
