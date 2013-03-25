class InvoiceItemsController < ApplicationController
  respond_to :json

  def index
    if params["invoice_id"]
      @invoice_items = InvoiceItem.find_all_by_invoice_id(params["invoice_id"])
      @items = []
      @invoice_items.each do |invoice_item|
        item = Item.find(invoice_item.item_id)
        @items.push({ id: item.id, code: item.code, brand: item.brand, season: item.season, entry: item.entry, quantity: invoice_item.quantity })
      end
      respond_with @items
    end
  end

  def create
  end

  def update
  end

  def show
  end

  def destroy
  end
end
