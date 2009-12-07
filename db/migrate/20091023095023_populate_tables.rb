class PopulateTables < ActiveRecord::Migration
  def self.up
    order = Order.create(:customer => 'Erika Mustermann', :order_date => DateTime.now)
    50.times do |i|
      amount = rand(10) + 1
      unit_price = (rand(5000) + 1).to_f / 100
      total_price = amount * unit_price
      order.items << Item.create(:name => "Item #{i}",
        :amount => amount,
        :unit_price => unit_price,
        :total_price => total_price)
    end
  end

  def self.down
    Order.destroy_all
  end
end
