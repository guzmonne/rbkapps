class CreateServiceRequests < ActiveRecord::Migration
  def change
    create_table :service_requests do |t|
      t.string :status
      t.string :priority
      t.text :solution
      t.date :closed_at
      t.integer :category_id
      t.string :title
      t.text :description
      t.integer :asigned_to_id
      t.string :location
      t.integer :creator_id

      t.timestamps
    end
  end
end
