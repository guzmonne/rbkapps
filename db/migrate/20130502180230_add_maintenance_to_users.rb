class AddMaintenanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :maintenance, :boolean
  end
end
