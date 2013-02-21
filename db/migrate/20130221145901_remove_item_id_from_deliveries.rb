class RemoveItemIdFromDeliveries < ActiveRecord::Migration
  def up
    remove_column :deliveries, :item_id
  end

  def down
    add_column :deliveries, :item_id, :integer
  end
end
