class CustomersList < Nk::Grid

  js_configure do |c|
    c.mixin
  end

  def configure(c)
    super
    c.model = "Customer"
    c.columns = [
		:name,
		:address,
		{name: :phone_number, header: "Phone #"},
		:active	
    ]
  end
  
  def default_bbar
	[:add_in_form, :edit_in_form, :del, :generate_invoice, :generate_invoice_for_all, :print]
  end
  
	action :generate_invoice do |a|
		a.icon = :bill
	end
  
	action :generate_invoice_for_all do |a|
		a.icon = :bill
	end
	
	action :print do |a|
		a.icon = :report
	end
	
	endpoint :generate_invoice_for_selected_customers do |params, me|
		ActiveRecord::Base.transaction do
			customers = Customer.active_customers.where({id: params[:customer_ids]})
			customers.each{|customer| customer.generate_invoice }
		end
	end
	
	endpoint :generate_invoice_for_all_customers do |params, me|
		ActiveRecord::Base.transaction do
			customers = Customer.active_customers
			customers.each{|customer| customer.generate_invoice }
		end
	end
	
	endpoint :get_report_url do |params, me|
		url = Customer.generate_balance_report
		file_name = File.basename(url)
		pre_generated_url = "/reports/read_generated_pdf/#{file_name[0..-5]}"
		me.netzke_set_result pre_generated_url
		pre_generated_url
	end
  
end
