class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.date :sale_date
      t.integer :price
      t.string :origin
      t.integer :units_available
      t.date :valid_since
      t.date :valid_until
      t.boolean :bundle
      t.boolean :deleted
      t.integer :media_channel_id
      t.integer :retailer_id
      t.integer :product_id

      t.timestamps
    end

    add_index :sales, :media_channel_id
    add_index :sales, :retailer_id
    add_index :sales, :product_id
  end
end
