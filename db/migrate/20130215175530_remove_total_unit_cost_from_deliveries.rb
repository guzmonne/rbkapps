class RemoveTotalUnitCostFromDeliveries < ActiveRecord::Migration
  def up
    remove_column :deliveries, :total_units_cost
  end

  def down
    add_column :deliveries, :total_units_cost, :string
  end
end
