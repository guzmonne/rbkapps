class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :category1
      t.string :category2
      t.string :category3

      t.timestamps
    end
  end
end
