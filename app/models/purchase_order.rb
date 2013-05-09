class PurchaseOrder < ActiveRecord::Base
  belongs_to :quotation
end
