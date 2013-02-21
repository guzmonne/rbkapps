class CreateDeliveriesItemsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :deliveries_items, :id => false do |t|
      t.integer :delivery_id
      t.integer :item_id
    end
  end

  def self.down
    drop_table :deliveries_items
  end
end
