class AddSomeFieldsToPurchaseRequests < ActiveRecord::Migration
  def change
    add_column :purchase_requests, :authorizer_id, :integer
    add_column :purchase_requests, :should_arrive_at, :date
    add_column :purchase_requests, :arrived_at, :date
    add_column :purchase_requests, :closed_at, :date
  end
end
