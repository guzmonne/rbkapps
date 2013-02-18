class RemoveFobTotalCostInvoiceNumberFromDeliveries < ActiveRecord::Migration
  def up
    remove_column :deliveries, :fob_total_cost
    remove_column :deliveries, :invoice_number
    remove_column :deliveries, :quantity
  end

  def down
    add_column :deliveries, :fob_total_cost, :decimal
    add_column :deliveries, :invoice_number, :string
    add_column :deliveries, :quantity, :integer
  end
end
