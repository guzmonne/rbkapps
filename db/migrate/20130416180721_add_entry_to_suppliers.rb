class AddEntryToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :entry, :string
  end
end
