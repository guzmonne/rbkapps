class AddTeamIdToPurchaseRequests < ActiveRecord::Migration
  def up
    add_column :purchase_requests, :team_id, :integer
  end
  def down
    remove_column :purchase_requests, :team_id, :integer
  end
end
