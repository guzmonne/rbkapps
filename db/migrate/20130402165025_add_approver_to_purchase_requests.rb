class AddApproverToPurchaseRequests < ActiveRecord::Migration
  def up
    add_column :purchase_requests, :approver, :integer
  end

  def down
    remove_column :purchase_requests, :approver
  end
end