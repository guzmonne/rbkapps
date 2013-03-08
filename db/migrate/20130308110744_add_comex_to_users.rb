class AddComexToUsers < ActiveRecord::Migration
  def up
    add_column :users, :comex, :boolean
  end

  def down
    remove_column :users, :comex
  end
end
