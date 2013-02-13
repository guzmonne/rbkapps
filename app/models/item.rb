class Item < ActiveRecord::Base
  attr_accessible :name,
                  :brand,
                  :season,
                  :entry

  validates :name, presence: {:message => "no puede quedar en blanco"}
  validates :brand, presence: {:message => "no puede quedar en blanco"}
  validates :season, presence: {:message => "no puede quedar en blanco"}
  validates :entry, presence: {:message => "no puede quedar en blanco"}
end
