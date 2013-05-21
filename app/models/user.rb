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

  def as_xls(options = {})
    {
        "Id" => id.to_s,
        "Nombre" => name,
        "E-Mail" => email,
        "Celular" => cellphone,
        "Ubicacion" => location,
        "Telefono" => phone,
        "Cargo" => position,
        "Equipo" => team,
        "Administrador" => admin,
        "COMEX" => comex,
        "Mantenimiento" => maintenance,
        "Gerente" => director
    }
  end

  def self.to_report
    @users = User.all
    @teams = Team.all
    @result = []
    @users.each do |u|
      team = @teams.detect {|f| f["id"] == u["team_id"]}

      @result.push({
                    :name => u["name"],
                    :email => u["email"],
                    :cellphone => u["cellphone"],
                    :location => u["location"],
                    phone: u["phone"],
                    position: u["position"],
                    team: team["name"],
                    admin: self.bool_to_yes(u["admin"]),
                    comex: self.bool_to_yes(u["comex"]),
                    maintenance: self.bool_to_yes(u["maintenance"]),
                    director: self.bool_to_yes(u["director"])
                   })
    end
    return @result
  end

  def self.bool_to_yes(var)
    if var == true then return "Si" else return nil end
  end

  def team
    Team.find(self.team_id).name
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
