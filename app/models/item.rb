class Item < ActiveRecord::Base
  attr_accessible :code,
                  :brand,
                  :season,
                  :entry

  validates :code, presence: {:message => "no puede quedar en blanco"}
  validates :brand, presence: {:message => "no puede quedar en blanco"}
  validates :season, presence: {:message => "no puede quedar en blanco"}
  validates :entry, presence: {:message => "no puede quedar en blanco"}
end
