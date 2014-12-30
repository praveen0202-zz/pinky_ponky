class CreateCustomers < ActiveRecord::Migration
  def up
	create_table(:customers) do |t|
		t.string :name, :null => false
		t.text :address
		t.integer :phone_number
		
		t.integer :lock_version
		t.timestamps
	end
  end

  def down
	drop_table :customers
  end
end
