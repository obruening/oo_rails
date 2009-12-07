class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :order_id
      t.string :name
      t.integer :amount
      t.decimal :unit_price, :precision => 6, :scale => 2
      t.decimal :total_price, :precision => 6, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
