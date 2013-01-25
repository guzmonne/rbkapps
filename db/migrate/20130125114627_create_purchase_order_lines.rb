class CreatePurchaseOrderLines < ActiveRecord::Migration
  def change
    create_table :purchase_order_lines do |t|
      t.integer :purchase_request_id
      t.string :description
      t.integer :quantity
      t.string :unit

      t.timestamps
    end
  end
end
