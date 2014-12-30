class AddColumnToCustomerBills < ActiveRecord::Migration
  def change
	add_column :customer_bills, :indent_number, :string
  end
end
