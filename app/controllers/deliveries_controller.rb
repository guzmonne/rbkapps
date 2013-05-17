class DeliveriesController < ApplicationController
  respond_to :json

  def index
    respond_with Delivery.all
  end

  def destroy
    Delivery.find(params["id"]).destroy
    @result = {status: :ok}
    respond_with @result
  end

  def show
    @report = params["id"]
    if @report == "days_to_dispatch"
      @deliveries = Delivery.all
      respond_to do |format|
        format.xls { send_data @deliveries.to_xls, content_type: 'application/vnd.ms-excel', filename: 'days_to_dispatch.xls' }
      end
      return
    end
    @delivery = Delivery.find(params["id"])
    @invoices = @delivery.invoices
    array = []
    @invoices.each do |invoice|
      aux = []
      invoice.invoice_items.each do |invoice_item|
        item = Item.find(invoice_item.item_id)
        aux.push({id: item.id, code: item.code, brand: item.brand, entry: item.entry, season:item.season, quantity: invoice_item.quantity})
      end
      array.push({invoice: invoice, invoice_items: aux})
    end
    @result = {delivery: @delivery, invoices: array}
    respond_with @result
  end

  def create
    @delivery       = Delivery.create(params["delivery"])
    @invoices       = params["invoices"]
    @new_invoices   = params["new_invoices"]
    @invoices.each do |invoice|
      model = Invoice.find(invoice["id"])
      model.delivery_id = @delivery.id
      model.save!
    end
    @new_invoices.each do |invoice|
      @model = Invoice.create(invoice["invoice"])
      @model.delivery_id = @delivery.id
      @model.save!
      invoice["old_items"].each do |old_item|
        InvoiceItem.create({invoice_id: @model.id, item_id: old_item["id"], quantity: old_item["quantity"]})
      end
      invoice["new_items"].each do |ni|
        item = Item.create({code: ni["code"], brand: ni["brand"], season: ni["season"], entry: ni["entry"]})
        InvoiceItem.create({invoice_id: @model.id, item_id: item.id, quantity: ni["quantity"]})
      end
    end
    respond_with @delivery
  end

  def update
    @delivery = Delivery.update(params["id"], params["delivery"])
    respond_with @delivery
  end
end
