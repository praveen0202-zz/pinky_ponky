class CreateProducts < ActiveRecord::Migration
  def up
	create_table(:products) do |t|
		t.string :product_name, :null => false
		
		t.integer :lock_version
		t.timestamps
	end
  end

  def down
	drop_table :products
  end
end
