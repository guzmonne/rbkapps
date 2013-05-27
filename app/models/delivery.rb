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

  def total_cost_usd
    if self.exchange_rate.to_f > 0
      if self.cargo_cost.nil? then c1 = 0 else c1 = self.cargo_cost.to_f end
      if self.cargo_cost2.nil? then c2 = 0 else c2 = self.cargo_cost2.to_f end
      if self.cargo_cost3.nil? then c3 = 0 else c3 = self.cargo_cost3.to_f end
      if self.dua_cost.nil? then c4 = 0 else c4 = self.dua_cost.to_f end
      if self.dispatch_cost.nil? then c5 = 0 else c5 = self.dispatch_cost.to_f end
      if self.exchange_rate.nil? then c6 = 0 else c6 = self.exchange_rate.to_f end
      return ( c1 + c2 + c3 + c4 + c5 ) / c6
    else
      return 0
    end
  end

  def invoice_total_cost_and_units
    @result = [0, 0]
    self.invoices.each do |invoice|
      @result[0] = @result[0] + invoice.total_units
      @result[1] = @result[1] + invoice.fob_total_cost
    end
    @result
  end

  def entry
    if self.invoices.length > 0
      if self.invoices[0].invoice_items.length
        Item.find(self.invoices[0].invoice_items[0].item_id).entry
      end
    else
      return "***"
    end
  end

  def business_days_between(date1, date2)
    business_days = 0
    if date2 < date1
      date   = date2
      datelo = date2
      datehi = date1
    else
      date   = date1
      datelo = date1
      datehi = date2
    end
    while datelo < datehi
      business_days = business_days + 1 unless datelo.saturday? or datelo.sunday?
      datelo = datelo + 1.day
    end
    business_days + 1 unless date.saturday? or date.sunday?
    business_days
  end
end
