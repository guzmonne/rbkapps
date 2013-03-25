class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string  :content, limit: 500
      t.integer :user_id
      t.string  :table_name
      t.integer :table_name_id
      t.timestamps
    end
  end
end
