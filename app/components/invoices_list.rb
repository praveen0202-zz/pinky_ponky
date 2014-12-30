class InvoicesList < Nk::Grid

  js_configure do |c|
    c.mixin
  end

  def configure(c)
    super
    c.model = "Invoice"
    c.title = "Invoices"
    c.columns = [
		{name: :invoice_number, label: "Invoice #", width: "10%"},
		{name: :customer__name, label: "Customer"},
		{name: :invoice_date, label: "Date", format: 'd/m/Y'},
		{name: :invoice_amount, label: "Amount", width: "10%"},
		{name: :previous_invoice_amount, label: "Prev Inv Amt"},
		{name: :previous_invoice_pending_amount, label: "Prev Inv Pending Amt", flex: 1},
		{name: :total_invoice_amount, label: "Total Inv Amt"},
		{name: :invoice_closed, label: "Closed?", width: "10%"},
		{name: :status, label: "Status", width: "10%", getter: lambda {|i| i.status.to_s } }
    ]
  end
  
  def default_bbar
	[:add_in_form, :edit_in_form, :del, :print]
  end
  
	action :print do |a|
		a.icon = :report
	end
	
	endpoint :get_invoice_report_url do |params, me|
		url = Invoice.pdf_url(params["invoice_ids"])
		file_name = File.basename(url)
		pre_generated_url = "/reports/read_generated_pdf/#{file_name[0..-5]}"
		me.netzke_set_result pre_generated_url
		pre_generated_url
	end
  
end
