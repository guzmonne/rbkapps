class CreateQuotations < ActiveRecord::Migration
  def change
    create_table :quotations do |t|
      t.integer :supplier_id
      t.string :method_of_payment
      t.text  :detail
      t.decimal :total_net, :precision => 8, :scale => 2
      t.decimal :iva, :precision => 8, :scale => 2
      t.timestamps
    end
  end
end
