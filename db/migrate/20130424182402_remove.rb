class Remove < ActiveRecord::Migration
  def up
    remove_column :purchase_requests, :arrived_at
  end

  def down
    add_column :purchase_requests, :arrived_at, :date
  end
end
