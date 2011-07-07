class LinkItemsToPropertyValues < ActiveRecord::Migration
  def self.up
    create_table :items_property_values, :id => false do |t|
      t.integer :item_id
      t.integer :property_value_id
    end
  end

  def self.down
    drop_table :items_property_values
  end
end
