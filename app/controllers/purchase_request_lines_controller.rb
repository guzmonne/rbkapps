class PurchaseRequestLinesController < ApplicationController

  respond_to :json
  def index
    @purchase_request_id = params["purchase_request_id"]
    respond_with PurchaseRequestLine.find_all_by_purchase_request_id(@purchase_request_id)
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
