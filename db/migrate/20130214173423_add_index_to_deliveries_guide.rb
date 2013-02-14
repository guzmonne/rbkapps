class AddIndexToDeliveriesGuide < ActiveRecord::Migration
  def change
    add_index :deliveries, :guide
  end
end
