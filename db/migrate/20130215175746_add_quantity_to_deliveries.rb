class AddQuantityToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :quantity, :integer
  end
end
