class AddUserIdToDeliveriesInvoicesAndItems < ActiveRecord::Migration
  def change
    add_column :deliveries, :user_id, :integer
    add_column :items, :user_id, :integer
    add_column :invoices, :user_id, :integer
  end
end
