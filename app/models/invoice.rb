class Invoice < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :delivery
  has_many :invoice_items, :dependent => :destroy
  has_many :items, :through => :invoice_items

  attr_accessible :invoice_number,
                  :fob_total_cost,
                  :total_units,
                  :delivery_id,
                  :user_id

  validate :invoice_number, :presence => true, :uniqueness => true

  def item_ids
    self.invoice_items.map {|x| x.item_id}
  end

end
