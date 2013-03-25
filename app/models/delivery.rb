class Delivery < ActiveRecord::Base
  has_many :invoices
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
                  :user_id,
                  :exchange_rate

  def next(id)
    delivery = Delivery.order("id").where('id > ?', id).first()
    if delivery.nil?
      return Delivery.order("id").first()
    else
      return delivery
    end
  end

  def previous(id)
    delivery = Delivery.order("id DESC").where('id < ?', id).first()
    if delivery.nil?
      return Delivery.order("id DESC").first()
    else
      return delivery
    end
  end
end
