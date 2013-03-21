class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :item

  attr_accessible :invoice_id,
                  :item_id,
                  :quantity
end
