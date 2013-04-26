class Item < ActiveRecord::Base
  has_many :invoice_items, :dependent => :destroy
  has_many :invoices, :through => :invoice_items
  attr_accessible :code,
                  :brand,
                  :season,
                  :entry,
                  :user_id

  validates :code, presence: {:message => "no puede quedar en blanco"}
  validates :brand, presence: {:message => "no puede quedar en blanco"}
  validates :season, presence: {:message => "no puede quedar en blanco"}
  validates :entry, presence: {:message => "no puede quedar en blanco"}


  def items_deliveries
    @items = Item.all(:include => [:invoices => :delivery])
    puts @items.length
    @result = []
    @i = 0
    @items.each do |i|
      @i = @i + 1
      if i.invoices.length > 0
        i.invoices.each do |invoice|
          if invoice.delivery == nil
            @result.push({id: i.id, code: i.code, brand: i.brand, season: i.season, entry: i.entry, invoice_number: invoice.invoice_number, delivery: nil, status: "PENDIENTE"})
            next
          else
            guide = invoice.delivery.guide
            unless invoice.delivery.guide2 == nil then guide = "#{guide} #{invoice.delivery.guide2}" end
            unless invoice.delivery.guide3 == nil then guide = "#{guide} #{invoice.delivery.guide3}" end
            if invoice.delivery.status == 'PENDIENTE' or invoice.delivery.status == 'PROCESO'
              status = 'PENDIENTE'
            else
              status = 'ENTREGADO'
            end
            @result.push({id: i.id, code: i.code, brand: i.brand, season: i.season, entry: i.entry, invoice_number: invoice.invoice_number, delivery: guide, status: status})
            next
          end
          next
        end
      else
        @result.push({id: i.id, code: i.code, brand: i.brand, season: i.season, entry: i.entry, invoice_number: nil, delivery: nil, status: 'S/E'})
        next
      end
    end
    puts @i
    puts @result.length
    return @result
  end

end