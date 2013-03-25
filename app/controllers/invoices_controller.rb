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
      @invoice.invoice_items << InvoiceItem.create({item_id: old_item["item_id"], quantity: old_item["quantity"]})
    end
    @new_items = params["new_items"]
    @new_items.each do |new_item|
      quantity = new_item["quantity"]
      new_item.delete("quantity")
      @item = Item.create(new_item)
      @invoice.invoice_items << InvoiceItem.create({item_id: @item.id, quantity: quantity})
    end
    respond_with @invoice
  end

  def update
    @invoice_attributes = params["invoice"]
    @invoice_attributes.delete("created_at")
    @invoice_attributes.delete("updated_at")
    @invoice = Invoice.update(params["id"], @invoice_attributes)
    @old_items = params["old_items"]
    @new_items = params["new_items"]
    @new_items.each do |new_item|
      quantity = new_item["quantity"]
      new_item.delete("quantity")
      @item = Item.create(new_item)
      @old_items << {item_id: @item.id, quantity: quantity}
    end
    @invoice.invoice_items.clear
    @old_items.each {|x| @invoice.invoice_items << InvoiceItem.create(x)}
    respond_with @invoice
  end

  def destroy
    Invoice.find(params["id"]).destroy
    @result = {status: :ok}
    respond_with @result
  end
end
