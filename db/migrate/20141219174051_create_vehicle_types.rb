class CreateVehicleTypes < ActiveRecord::Migration
  def up
	create_table(:vehicle_types) do |t|
		t.string :vehicle_name, :null => false
		
		t.integer :lock_version
		t.timestamps
	end
  end

  def down
	drop_table :vehicle_types
  end
end
