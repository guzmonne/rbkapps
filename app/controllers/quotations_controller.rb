class QuotationsController < ApplicationController
  respond_to :json

  def index
    if params["purchase_request_id"]
      @purchase_request = PurchaseRequest.find(params["purchase_request_id"])
      respond_with @purchase_request.quotations
    else
      respond_with Quotations.all
    end
  end

  def show
    respond_with Quotation.find(params["id"])
  end

  def create
    respond_with Quotation.create(params["quotation"])
  end

  def update
    respond_with Quotation.update(params["id"], params["quotation"])
  end

  def destroy
    Quotation.find(params["id"]).destroy
    @result = {status: :ok}
    respond_with @result
  end
end
