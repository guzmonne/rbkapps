class Category < ActiveRecord::Base
  has_many :service_requests

  attr_accessible :category1,
                  :category2,
                  :category3
end
