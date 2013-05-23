class ItemsController < ApplicationController
  respond_to :json

  def index
    if params["delivery_id"]
      @delivery = Delivery.find(params["delivery_id"])
      respond_with @delivery.items
    else
      @items = Item.items_deliveries
      respond_to do |format|
        format.json { render :json => Item.items_deliveries }
        format.xls
      end
      #respond_with Item.items_deliveries
    end
  end

  def show
    @format = params["id"]
    if @format == "items_status"
      @items = Item.all
      respond_to do |format|
        format.json  { render :json => Item.items_deliveries }
        format.xls
      end
    else
      respond_with Item.find(params["id"])
    end
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

  def import
    Item.import(params[:file])
    redirect_to '/items/index'
  end
end
