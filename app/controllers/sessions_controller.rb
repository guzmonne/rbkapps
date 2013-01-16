class SessionsController < ApplicationController
  respond_to :json
  def create
    user = User.find_by_email(params["session"]["email"].downcase)
    if user && user.authenticate(params["session"]["password"])
      respond_with user
    else
      respond_with('error', :status => 401, :location => nil)
    end
  end

  def show
    respond_with User.find_by_remember_token(params[:remember_token])
  end
end
