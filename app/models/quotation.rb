class Quotation < ActiveRecord::Base
  belongs_to :supplier
  belongs_to :purchase_request

  attr_accessible :detail,
                  :iva,
                  :method_of_payment,
                  :supplier_id,
                  :total_net,
                  :purchase_request_id,
                  :selected

end
