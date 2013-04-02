class AddDetailToPurchaseRequest < ActiveRecord::Migration
  def up
    add_column :purchase_requests, :detail, :text
  end
  def down
    remove_column :purchase_requests, :detail
  end
end
