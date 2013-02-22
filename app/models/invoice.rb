class Invoice < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :delivery

  attr_accessible :invoice_number,
                  :fob_total_cost,
                  :total_units,
                  :delivery_id,
                  :user_id

end
