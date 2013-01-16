class AddUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :position
      t.string :phone
      t.string :cellphone
      t.integer :location_id
      t.integer :team_id

      t.timestamps
    end
  end

  def down
      drop_table :users
  end
end
