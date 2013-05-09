class User < ActiveRecord::Base
  has_secure_password
  has_many :purchase_requests
  belongs_to :team
  attr_accessor :team_name
  attr_accessible :name,
                  :email,
                  :cellphone,
                  :location,
                  :password_confirmation,
                  :password,
                  :phone,
                  :position,
                  :remember_token,
                  :team_id,
                  :admin,
                  :comex,
                  :compras,
                  :maintenance,
                  :director

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

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
