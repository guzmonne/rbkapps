class AddCostCenterToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :cost_center, :string
  end
end
