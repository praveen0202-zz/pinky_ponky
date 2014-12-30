class CreateProductPrices < ActiveRecord::Migration
  def up
	create_table(:product_prices) do |t|
		t.integer :product_id, :null => false
		t.decimal :rate, :precision => 10, :scale => 2, null: false
		t.date :effective_from, :null => false
		t.date :effective_to
		
		t.integer :lock_version
		t.timestamps
	end
  end

  def down
	drop_table :product_prices
  end
end
