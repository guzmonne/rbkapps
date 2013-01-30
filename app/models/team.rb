class Team < ActiveRecord::Base
  has_many :users

  attr_accessible :name,
                  :supervisor_id,
                  :director_id

  validates :name, presence: {:message => "no puede quedar en blanco"}
  validates :supervisor_id, presence: {:message => "no puede quedar en blanco"}
  validates :director_id, presence: {:message => "no puede quedar en blanco"}
end
