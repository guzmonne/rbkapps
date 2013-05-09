class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.integer :quotation_id
      t.text :observations

      t.timestamps
    end
  end
end
