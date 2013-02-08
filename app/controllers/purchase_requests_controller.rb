class PurchaseRequestsController < ApplicationController
  respond_to :json
  def index
    @user_id = params["user_id"]
    @user = User.find(@user_id)
    @team = Team.find(@user.team_id)
    if @user.admin == true
      respond_with PurchaseRequest.all
    elsif @team.supervisor_id == @user.id
      respond_with PurchaseRequest.find_all_by_team_id(@team.id)
    else
      respond_with PurchaseRequest.find_all_by_user_id(@user_id)
    end
  end

  def show
    respond_with PurchaseRequest.find(params["id"])
  end

  def create
    @purchase_request = params["purchase_request"]
    @purchase_request_lines = params["purchase_request_lines"]
    @result = PurchaseRequest.create(params["purchase_request"])
    @purchase_request_lines.each do |line|
        line["purchase_request_id"] = @result["id"]
        PurchaseRequestLine.create(line)
    end
    respond_with @result
  end

  def update
    respond_with PurchaseRequest.update(params["id"], params["purchase_request"])
  end
end
