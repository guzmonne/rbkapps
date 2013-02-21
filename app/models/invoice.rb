class Invoice < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  attr_accessible :invoice_number,
                  :fob_total_cost,
                  :total_units,
                  :delivery_id

end
