class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :invoice_number
      t.decimal :fob_total_cost, :precision => 8, :scale => 2
      t.integer :total_units
      t.integer :delivery_id

      t.timestamps
    end
  end
end
