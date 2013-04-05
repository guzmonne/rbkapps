class Team < ActiveRecord::Base
  has_many :users

  attr_accessible :name,
                  :supervisor_id,
                  :director_id,
                  :cost_center

  validates :name, presence: {:message => "no puede quedar en blanco"}

  def team_members
    array = []
    users = User.where("team_id = ?", self.id)
    users.each do |u|
      array.push(u.id)
    end
    return array
  end
end
