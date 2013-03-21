class InvoicesController < ApplicationController
  respond_to :json

  def index
    if params["delivery_id"]
      @delivery = Delivery.find(params["delivery_id"])
      respond_with @delivery.invoices
    else
      respond_with Invoice.all
    end
  end

  def show
    respond_with Invoice.find(params["id"])
  end

  def create
    @invoice = Invoice.create(params["invoice"])
    @old_items = params["old_items"]
    @old_items.each do |old_item|
      InvoiceItem.create({invoice_id: @invoice.id, item_id: old_item["id"], quantity: old_item["quantity"]})
    end
    @new_items = params["new_items"]
    @new_items.each do |new_item|
      quantity = new_item["quantity"]
      new_item.delete("quantity")
      @item = Item.create(new_item)
      InvoiceItem.create({invoice_id: @invoice.id, item_id: @item.id, quantity: quantity})
    end
    respond_with @invoice
  end

  def update
    respond_with Invoice.update(params["id"], params["invoice"])
  end
end
