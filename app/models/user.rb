class User < ActiveRecord::Base
  has_secure_password
  has_many :purchase_requests
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

  validates :name, presence: {:message => "no puede quedar en blanco"}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: {:message => "no puede quedar en blanco"},
            format: { with: VALID_EMAIL_REGEX, :message => "e-mail invalido" },
            uniqueness: { case_sensitive: false, :message => "la direccion ya esta en uso" }
  validates :password, length: { minimum: 6, :message => "debe tener por lo menos 6 caracteres" }
  validates :password_confirmation, presence: {:message => "no puede quedar en blanco"}

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
