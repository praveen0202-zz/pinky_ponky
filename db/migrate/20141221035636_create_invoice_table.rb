class CreateInvoiceTable < ActiveRecord::Migration

  def up
	create_table(:invoices) do |t|
		t.integer :customer_id, :null => false
		t.date :invoice_date, :null => false
		t.decimal :invoice_amount, :precision => 10, :scale => 2, null: false
		
		t.integer :lock_version
		t.timestamps
	end
	add_column :customer_bills, :invoice_id, :integer
	create_table(:invoice_payments) do |t|
		t.integer :invoice_id, :null => false
		t.integer :customer_id, :null => false
		t.decimal :amount_paid, :precision => 10, :scale => 2, null: false
		t.date :paid_date, :precision => 10, :scale => 2, null: false
		
		t.integer :lock_version
		t.timestamps
	end
  end

  def down
	drop_table :invoices
	drop_table :invoice_payments
  end
  
end
