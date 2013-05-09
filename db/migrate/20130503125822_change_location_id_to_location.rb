class ChangeLocationIdToLocation < ActiveRecord::Migration
  def up
    add_column :users, :location, :string
    remove_column :users, :location_id
  end

  def down
    add_column :users, :location_id, :integer
    remove_column :users, :location
  end
end
