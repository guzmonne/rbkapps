class InvoicesController < ApplicationController
  respond_to :json

  def index
    respond_with Invoice.find_all_by_delivery_id(params["delivery_id"])
  end

  def show
    respond_with Invoice.find(params["id"])
  end

  def create
    respond_with Invoice.create(params["invoice"])
  end

  def update
    respond_with Invoice.update(params["id"], params["invoice"])
  end
end
