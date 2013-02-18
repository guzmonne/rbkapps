class DeliveriesController < ApplicationController
  respond_to :json

  def index
    respond_with Delivery.all
  end

  def show
    respond_with Delivery.find(params["id"])
  end

  def create
    @delivery = params["delivery"]
    @invoices = params["invoices"]
    @result = Delivery.create(@delivery)
    @invoices.each do |invoice|
      invoice["delivery_id"] = @result["id"]
      Invoice.create(invoice)
    end
    respond_with @result
  end

  def update
    respond_with Delivery.update(params["id"], params["delivery"])
  end
end
