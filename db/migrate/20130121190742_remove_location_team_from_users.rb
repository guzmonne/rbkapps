class RemoveLocationTeamFromUsers < ActiveRecord::Migration
  def up
    remove_column :users,
  end

  def down
  end
end
