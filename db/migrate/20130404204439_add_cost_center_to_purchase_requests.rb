class AddCostCenterToPurchaseRequests < ActiveRecord::Migration
  def change
    add_column :purchase_requests, :cost_center, :string
  end
end
