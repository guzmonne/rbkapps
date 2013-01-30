class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :supervisor_id
      t.integer :director_id

      t.timestamps
    end
    add_index :teams, :supervisor_id
  end
end
