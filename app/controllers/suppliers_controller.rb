class SuppliersController < ApplicationController
  respond_to :json

  def index
      respond_with Supplier.all
  end

  def show
    respond_with Supplier.find(params["id"])
  end

  def create
    respond_with Supplier.create(params["supplier"])
  end

  def update
    respond_with Supplier.update(params["id"], params["supplier"])
  end

  def destroy
    Supplier.find(params["id"]).destroy
    @result = {status: :ok}
    respond_with @result
  end
end
