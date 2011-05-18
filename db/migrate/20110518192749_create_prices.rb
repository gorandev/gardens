class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.integer :item_id
      t.date :price_date
      t.integer :currency_id
      t.integer :price

      t.timestamps
    end
    add_index :prices, :item_id
    add_index :prices, :currency_id
  end

  def self.down
    drop_table :prices
  end
end
