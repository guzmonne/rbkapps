class AddItemIdToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :item_id, :integer
  end
end
