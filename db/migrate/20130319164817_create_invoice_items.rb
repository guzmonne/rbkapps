class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.integer :invoice_id
      t.integer :item_id
      t.integer :quantity

      t.timestamps
    end
    drop_table :deliveries_items
  end
end
