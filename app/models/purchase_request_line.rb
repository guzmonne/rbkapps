class PurchaseRequestLine < ActiveRecord::Base
  belongs_to :purchase_request

  attr_accessible :purchase_request_id,
                  :description,
                  :unit,
                  :quantity
end
