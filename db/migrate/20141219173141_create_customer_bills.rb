class CreateCustomerBills < ActiveRecord::Migration
  def up
	create_table(:customer_bills) do |t|
		t.integer :customer_id, :null => false
		t.integer :product_id, :null => false
		t.integer :bill_number, :null => false
		t.integer :customer_vehicle_id, :null => false
		t.date :bill_date, :null => false
		t.integer :product_price_id, :null => false
		t.decimal :quantity, :precision => 10, :scale => 2, null: false
		t.decimal :bill_amount, :precision => 10, :scale => 2, null: false
		t.string :status, null: false
		
		t.integer :lock_version
		t.timestamps
	end
  end

  def down
	drop_table :customer_bills
  end
end
