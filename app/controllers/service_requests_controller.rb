class ServiceRequestsController < ApplicationController
  respond_to :json

  def index
    respond_with ServiceRequest.all
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
end
