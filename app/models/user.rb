class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :name,
                  :email,
                  :cellphone,
                  :location_id,
                  :password_confirmation,
                  :password,
                  :phone,
                  :position,
                  :remember_token,
                  :team_id,
                  :admin
  before_save do |user|
    user.email = email.downcase
    user.name  = name.titleize
  end
  before_save :create_remember_token

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
