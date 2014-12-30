class CreateCustomerVehicles < ActiveRecord::Migration
  def up
	create_table(:customer_vehicles) do |t|
		t.integer :customer_id, :null => false
		t.integer :vehicle_type_id, :null => false
		t.string :vehicle_number, :null => false
		
		t.integer :lock_version
		t.timestamps
	end
  end

  def down
	drop_table :customer_vehicles
  end
end
