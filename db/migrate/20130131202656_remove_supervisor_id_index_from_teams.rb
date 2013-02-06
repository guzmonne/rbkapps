class RemoveSupervisorIdIndexFromTeams < ActiveRecord::Migration
  def change
    remove_index :teams, :supervisor_id
  end
end
