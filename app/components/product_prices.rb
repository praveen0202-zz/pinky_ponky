class ProductPrices < Nk::Grid

  def configure(c)
    super
    c.model = "ProductPrice"
    c.title = "Product Rates"
    c.columns = [
		{name: :product__product_name, label: "Product"},	
		:rate,
		{name: :effective_from, header: "Effective From", format: 'd/m/Y'},
		{name: :effective_to, header: "Effective To", format: 'd/m/Y'}	
    ]
  end
  
  def default_bbar
	[:add_in_form, :edit_in_form, :del]
  end
  
end
