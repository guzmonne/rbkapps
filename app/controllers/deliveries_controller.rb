class DeliveriesController < ApplicationController
  respond_to :json

  def index
    respond_with Delivery.all
  end

  def show
    respond_with Delivery.find(params["id"])
  end

  def create
    respond_with Delivery.create(params["delivery"])
  end

  def update
    respond_with Delivery.update(params["id"], params["delivery"])
  end
end
