class AddPurchaseRequestIdToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :purchase_request_id, :integer
  end
end
