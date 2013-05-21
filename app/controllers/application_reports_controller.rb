class ApplicationReportsController < ApplicationController
  def index
    @report = params["report"]
    if @report == 'users'
      @users = User.to_report
      respond_to do |format|
        format.xls  { render :action => 'users' }
      end
    end
  end
end