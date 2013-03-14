class AddExchangeRateToDelivery < ActiveRecord::Migration
  def up
    add_column :deliveries, :exchange_rate, :decimal, :precision => 8, :scale => 2
  end

  def down
    remove_column :deliveries, :exchange_rate
  end
end
