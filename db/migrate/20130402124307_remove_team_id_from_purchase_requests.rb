class RemoveTeamIdFromPurchaseRequests < ActiveRecord::Migration
  def up
    remove_column :purchase_requests, :team_id
  end
  def down
    remove_column :purchase_requests, :team_id, :integer
  end
end

