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

  def as_xls(options = {})
    {
        "Id" => id.to_s,
        "Tramite" => dispatch,
        "Guias" => guides,
        "Fecha de Llegada" => arrival_date,
        "Fecha de Entrega" => delivery_date,
        "Dias para despachar" => days_to_dispatch,
    }
  end

  def guides
    "#{self.guide} #{self.guide2} #{self.guide3}"
  end

  def days_to_dispatch
    return nil if self.delivery_date == nil || self.arrival_date == nil
    business_days_between(self.delivery_date, self.arrival_date)
    #(self.delivery_date - self.arrival_date).round.abs
  end

  def business_days_between(date1, date2)
    business_days = 0
    if date2 < date1
      datelo = date2
      datehi = date1
    else
      datelo = date1
      datehi = date2
    end
    while datelo < datehi
      business_days = business_days + 1 unless datelo.saturday? or datelo.sunday?
      datelo = datelo + 1.day
    end
    business_days + 1
  end
end
