class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :status
      t.integer :product_type_id
      t.boolean :show_on_search

      t.timestamps
    end
    add_index :products, :product_type_id
  end

  def self.down
    drop_table :products
  end
end
