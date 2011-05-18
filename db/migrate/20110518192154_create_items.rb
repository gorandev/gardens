class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :product_id
      t.integer :retailer_id

      t.timestamps
    end
    add_index :items, :product_id
    add_index :items, :retailer_id
  end

  def self.down
    drop_table :items
  end
end
