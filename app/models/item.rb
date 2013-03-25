class Item < ActiveRecord::Base
  has_many :invoice_items, :dependent => :destroy
  has_many :invoices, :through => :invoice_items
  attr_accessible :code,
                  :brand,
                  :season,
                  :entry,
                  :user_id

  validates :code, presence: {:message => "no puede quedar en blanco"}
  validates :brand, presence: {:message => "no puede quedar en blanco"}
  validates :season, presence: {:message => "no puede quedar en blanco"}
  validates :entry, presence: {:message => "no puede quedar en blanco"}
end
