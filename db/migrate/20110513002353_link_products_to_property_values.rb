class LinkProductsToPropertyValues < ActiveRecord::Migration
  def self.up
    create_table :products_property_values, :id => false do |t|
      t.integer :product_id
      t.integer :property_value_id
    end
  end

  def self.down
    drop_table :products_property_values
  end
end
