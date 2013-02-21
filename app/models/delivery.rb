class Delivery < ActiveRecord::Base
  has_and_belongs_to_many :items

  attr_accessible :courier,
                  :dispatch,
                  :guide,
                  :guide2,
                  :guide3,
                  :cargo_cost,
                  :cargo_cost2,
                  :cargo_cost3,
                  :dispatch_cost,
                  :dua_cost,
                  :supplier,
                  :origin,
                  :origin_date,
                  :arrival_date,
                  :delivery_date,
                  :status,
                  :invoice_delivery_date,
                  :doc_courier_date,
                  :item_id

end
