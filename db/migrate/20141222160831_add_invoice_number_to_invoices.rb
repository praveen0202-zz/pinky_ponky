class AddInvoiceNumberToInvoices < ActiveRecord::Migration
  def change
	add_column :invoices, :invoice_number, :string
	add_column :invoice_payments, :invoice_payment_number, :string
  end
end
