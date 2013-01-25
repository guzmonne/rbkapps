class AddStateToPurchaseRequests < ActiveRecord::Migration
  def up
    add_column :purchase_requests, :state, :string
  end
  def down
    remove_column :users, :admin
  end
end
