class ChangeGuidesColumnsFromIntegerToStringd < ActiveRecord::Migration
  def up
    remove_column :deliveries, :guide
    remove_column :deliveries, :guide2
    remove_column :deliveries, :guide3
    add_column :deliveries, :guide, :string
    add_column :deliveries, :guide2, :string
    add_column :deliveries, :guide3, :string
  end

  def down
    remove_column :deliveries, :guide
    remove_column :deliveries, :guide2
    remove_column :deliveries, :guide3
    add_column :deliveries, :guide, :integer
    add_column :deliveries, :guide2, :integer
    add_column :deliveries, :guide3, :integer
  end
end
