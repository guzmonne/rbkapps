class Supplier < ActiveRecord::Base
  has_many :quotations

  attr_accessible :name,
                  :phone,
                  :email,
                  :address,
                  :contact,
                  :contact_phone,
                  :contact_email,
                  :method_of_payment
end
