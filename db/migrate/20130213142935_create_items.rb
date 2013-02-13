class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :brand
      t.string :season
      t.string :entry
      t.string :name

      t.timestamps
    end
  end
end
