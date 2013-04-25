class PurchaseRequestsController < ApplicationController
  respond_to :json
  def index
    @user_id = params["user_id"]
    @user = User.find(@user_id)
    @team = Team.find(@user.team_id)
    @team_members = @team.team_members
    if @user.admin == true or @user.compras == true or @user.director == true
      respond_with PurchaseRequest.all
    elsif @team.supervisor_id == @user.id
      array = []
      PurchaseRequest.all.each do |p|
        if @team_members.include? p.user_id
          array.push(p)
        end
      end
      respond_with array
    else
      respond_with PurchaseRequest.find_all_by_user_id(@user_id)
    end
  end

  def show
    respond_with PurchaseRequest.find(params["id"])
  end

  def create
    respond_with PurchaseRequest.create(params["purchase_request"])
  end

  def update
    respond_with PurchaseRequest.update(params["id"], params["purchase_request"])
  end
end
