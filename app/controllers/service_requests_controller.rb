class ServiceRequestsController < ApplicationController
  respond_to :json

  def index
    respond_with ServiceRequest.for_user(params["user_id"])
  end

  def show
    respond_with ServiceRequest.find(params["id"])
  end

  def create
    respond_with ServiceRequest.create(params["service_request"])
  end

  def update
    respond_with ServiceRequest.update(params["id"], params["service_request"])
  end

  def destroy
    ServiceRequest.find(params["id"]).destroy
    @result = {status: :ok}
    respond_with @result
  end
end
