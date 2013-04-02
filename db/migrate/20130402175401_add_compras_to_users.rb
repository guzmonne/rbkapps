class AddComprasToUsers < ActiveRecord::Migration
  def change
    add_column :users, :compras, :boolean
  end
end
