class RemoveItemsNameAndAddCode < ActiveRecord::Migration
  def up
    remove_column :items, :name
    add_column :items, :code, :string
  end

  def down
    remove_column :items, :code
    add_column :items, :name, :string
  end
end
