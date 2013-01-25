class PurchaseRequestsController < ApplicationController
  respond_to :json
  def index
    respond_with PurchaseRequest.all
  end

  def show
    respond_with PurchaseRequest.find(params["id"])
  end

  def create
    respond_with PurchaseRequest.create(params["purchase_request"])
  end

  def update
    respond_with PurchaseRequest.update(params["id"], params["purchase_request"])
  end
end
