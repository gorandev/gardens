class AddProductTypeToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :product_type_id, :integer
    add_index :items, :product_type_id
  end

  def self.down
    remove_column :items, :product_type_id
  end
end
