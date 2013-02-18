class Invoice < ActiveRecord::Base
  attr_accessible :invoice_number,
                  :fob_total_cost,
                  :total_units,
                  :delivery_id
end
