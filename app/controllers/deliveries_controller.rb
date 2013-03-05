class DeliveriesController < ApplicationController
  respond_to :json

  def index
    respond_with Delivery.all
  end

  def show
    respond_with Delivery.find(params["id"])
  end

  def create
    @invoices       = params["invoices"]
    @items          = params["items"]
    @edit_invoices  = params["editInvoices"]
    @edit_items     = params["editItems"]
    @delivery       = Delivery.create(params["delivery"])
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
    respond_with @delivery
  end

  def update
    @invoices       = params["invoices"]
    @items          = params["items"]
    @edit_invoices  = params["editInvoices"]
    @edit_items     = params["editItems"]
    @remove_items   = params["removeItems"]
    @remove_invoices= params["removeInvoices"]
    @delivery       = Delivery.update(params["id"],params["delivery"])
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
