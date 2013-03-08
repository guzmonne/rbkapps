class UsersController < ApplicationController
  respond_to :json

  def index
    @remember_token = params["remember_token"]
    unless @remember_token == nil
      @user = User.find_by_remember_token(@remember_token)
      respond_with(@user)
    else
      respond_with User.all
    end
  end

  def show
    return respond_with User.find(params["id"]) if params["id"]
    remember_token = params["remember_token"]
    @user = User.find_by_remember_token(remember_token)
    respond_with(@user)
  end

  def create
    respond_with User.create(params["user"])
  end

  def update
    respond_with User.update(params["id"], params["user"])
  end
end
