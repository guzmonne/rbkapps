class CreatePurchaseRequests < ActiveRecord::Migration
  def change
    create_table :purchase_requests do |t|
      t.integer :user_id
      t.string  :sector
      t.date  :deliver_at
      t.string :use


      t.timestamps
    end
  end
end
