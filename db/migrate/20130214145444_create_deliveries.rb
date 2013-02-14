class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.string :courier
      t.string :dispatch
      t.integer :guide
      t.integer :guide2
      t.integer :guide3
      t.decimal :cargo_cost, :precision => 8, :scale => 2
      t.decimal :cargo_cost2, :precision => 8, :scale => 2
      t.decimal :cargo_cost3, :precision => 8, :scale => 2
      t.decimal :dispatch_cost, :precision => 8, :scale => 2
      t.decimal :dua_cost, :precision => 8, :scale => 2
      t.string :supplier
      t.string :origin
      t.date :origin_date
      t.date :arrival_date
      t.date :delivery_date
      t.text :status
      t.date :invoice_delivery_date
      t.date :doc_courier_date
      t.integer :invoice_number
      t.decimal :fob_total_cost, :precision => 8, :scale => 2
      t.decimal :total_units_cost, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
