class CreateUniqueNumberGenerator < ActiveRecord::Migration
  def up
	create_table(:unique_identifiers) do |t|
		t.string :identifier, :null => false
		t.string :type
		
		t.integer :lock_version
		t.timestamps
	end
	add_column :customers, :active, :boolean, :default => true
	add_column :invoices, :status, :string, :null => false
	UniqueIdentifier.create({identifier: "00000", type: "Invoice"})
  end

  def down
	drop_table :unique_identifiers
  end
end
