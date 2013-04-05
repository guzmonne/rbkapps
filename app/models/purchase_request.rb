class PurchaseRequest < ActiveRecord::Base
  belongs_to :user
  has_many :purchase_request_lines

  attr_accessible :user_id,
                  :deliver_at,
                  :sector,
                  :use,
                  :state,
                  :detail,
                  :approver,
                  :cost_center

  validates :user_id, :presence => {:message => "el pedido de be pertenecer a un usuario"}
  validates :deliver_at, :presence => {:message => "debe aclarar una fecha de entrega"}
  validates :sector, :presence => {:message => "el pedido debe estar asignado a un sector"}

end
