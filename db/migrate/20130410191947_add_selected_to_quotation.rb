class AddSelectedToQuotation < ActiveRecord::Migration
  def change
    add_column :quotations, :selected, :boolean
  end
end
