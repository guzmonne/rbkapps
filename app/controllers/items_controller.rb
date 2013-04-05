class ItemsController < ApplicationController
  respond_to :json

  def index
    if params["delivery_id"]
      @delivery = Delivery.find(params["delivery_id"])
      respond_with @delivery.items
    else
      respond_with Item.all
    end
  end

  def show
    respond_with Item.find(params["id"])
  end

  def create
    respond_with Item.create(params["item"])
  end

  def update
    respond_with Item.update(params["id"], params["item"])
  end

  def destroy
    Item.find(params["id"]).destroy
    @result = {status: :ok}
    respond_with @result
  end
end
