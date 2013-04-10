class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :address
      t.string :contact
      t.string :contact_phone
      t.string :contact_email
      t.string :method_of_payment

      t.timestamps
    end
  end
end
