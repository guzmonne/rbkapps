class ServiceRequestsController < ApplicationController
  respond_to :json

  def index
    respond_with ServiceRequest.for_user(params["user_id"])
  end

  def show
    respond_with ServiceRequest.find(params["id"])
  end

  def create
    @service_request = ServiceRequest.new(params["service_request"])
    respond_to do |format|
      if @service_request.save
        # Despues de que graba
        ServiceRequestMailer.service_request_created_email(User.find(@service_request.creator_id), @service_request)

        format.json { render :json => @service_request, :status => :created, :location => @service_request }
      end
    end
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
