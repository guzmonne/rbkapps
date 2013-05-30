class ApplicationReportsController < ApplicationController
  def index
    @report = params["report"]
    if @report == 'users'
      @users = User.to_report
      respond_to do |format|
        format.xls  { render :action => 'users' }
      end
    elsif @report == 'service_requests'
      @services = ServiceRequest.for_user(params["user_id"])
      respond_to do |format|
        format.xls  { render :action => 'service_requests' }
      end
    end
  end
end