class DeliveriesController < ApplicationController
  respond_to :json

  def index
    respond_with Delivery.all
  end

  def show
    respond_with Delivery.find(params["id"])
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
    @invoices       = params["invoices"]
    @items          = params["items"]
    @edit_invoices  = params["editInvoices"]
    @edit_items     = params["editItems"]
    @remove_items   = params["removeItems"]
    @remove_invoices= params["removeInvoices"]
    @delivery       = Delivery.find(params["id"])
    Delivery.update(params["id"],params["delivery"])
    @invoices.each do |invoice|
      invoice["delivery_id"] = @delivery["id"]
      Invoice.create(invoice)
    end
    @items.each do |item|
      @delivery.items.push Item.create(item)
    end
    @edit_invoices.each do |invoice_id|
      Invoice.update(invoice_id, {delivery_id: @delivery.id})
    end
    @edit_items.each do |item_id|
      @delivery.items.push Item.find(item_id)
    end
    @remove_invoices.each do |invoice|
      Invoice.update(invoice["id"], {delivery_id: nil })
    end
    @remove_items.each do |item|
      @delivery.items.delete Item.find(item["id"])
    end
    respond_with @delivery
  end
end
