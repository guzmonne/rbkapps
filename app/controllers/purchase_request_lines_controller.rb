class PurchaseRequestLinesController < ApplicationController

  respond_to :json
  def index
    respond_with PurchaseRequestLine.all
  end

  def show
    respond_with PurchaseRequestLine.find(params["id"])
  end

  def create
    respond_with PurchaseRequestLine.create(params["purchase_request_line"])
  end

  def update
    respond_with PurchaseRequestLine.update(params["id"], params["purchase_request_line"])
  end
end
