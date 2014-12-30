class AddColumnsToInvoices < ActiveRecord::Migration
  def change
	add_column :invoices, :previous_invoice_amount, :decimal, :precision => 10, :scale => 2
	add_column :invoices, :previous_invoice_paid_amount, :decimal, :precision => 10, :scale => 2
	add_column :invoices, :invoice_closed, :boolean, :default => false
	add_column :invoices, :total_invoice_amount, :decimal, :precision => 10, :scale => 2
	add_column :invoices, :previous_invoice_pending_amount, :decimal, :precision => 10, :scale => 2
  end
end
