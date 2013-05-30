class ServiceRequest < ActiveRecord::Base
  belongs_to :category
  belongs_to :user, :foreign_key => :creator_id

  attr_accessible        :status,
                         :priority,
                         :solution,
                         :closed_at,
                         :category_id,
                         :title,
                         :description,
                         :asigned_to_id,
                         :location,
                         :creator_id,
                         :modified_by

  def self.from_team (team_id)
    @users = User.find_all_by_team_id(team_id)
    @service_requests = []
    for user in @users
      services = ServiceRequest.find_all_by_creator_id(user.id)
      if services.length > 0
        for service in services
        @service_requests << service
        end
      end
    end
    return @service_requests
  end

  def self.for_user (user_id)
    @user = User.find(user_id)
    if @user.admin or @user.maintenance
      return ServiceRequest.all
    elsif @user.is_supervisor
      @service_requests = ServiceRequest.from_team(@user.team_id)
      return @service_requests
    else
      @service_requests = ServiceRequest.find_all_by_creator_id(@user.id)
      return @service_requests
    end
  end
end
