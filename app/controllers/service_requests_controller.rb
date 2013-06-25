class ServiceRequestsController < ApplicationController
  respond_to :json

  def index
    if params["to"] and params["from"]
      to = params["to"]
      from = params["from"]
      if params["status"]
        estado = params["status"]
      else
        estado = "Cerrado"
      end
      if estado == "all"
        if to != "" and from == ""
          return respond_with ServiceRequest.where("created_at <= ?", Time.parse(to) + 1.days)
        elsif to == "" and from != ""
          return respond_with ServiceRequest.where("created_at >= ?", from)
        elsif to != "" and from != ""
          return respond_with ServiceRequest.where("created_at >= ? AND created_at <= ?", from, Time.parse(to) + 1.days)
        elsif to == "" and from == ""
          return respond_with ServiceRequest.all
        end
      else
        if to != "" and from == ""
          return respond_with ServiceRequest.where("status = ? AND closed_at <= ?", estado, Time.parse(to) + 1.days)
        elsif to == "" and from != ""
          return respond_with ServiceRequest.where("status = ? AND closed_at >= ?", estado, from)
        elsif to != "" and from != ""
          return respond_with ServiceRequest.where("status = ? AND closed_at >= ? AND closed_at <= ?", estado, from, Time.parse(to) + 1.days)
        elsif to == "" and from == ""
          return respond_with ServiceRequest.where("status = ?", estado)
        end
      end
    else
      respond_with ServiceRequest.for_user(params["user_id"])
    end
  end

  def show
    respond_with ServiceRequest.find(params["id"])
  end

  def create
    @service_request = ServiceRequest.new(params["service_request"])
    respond_to do |format|
      if @service_request.save
        # Despues de que graba
        # ServiceRequestMailer.service_request_created_email(User.find(@service_request.creator_id), @service_request)
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
