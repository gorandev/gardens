class AddImagenToItemAndProduct < ActiveRecord::Migration
  def self.up
    add_column :items, :imagen_id, :integer
    add_column :products, :imagen_id, :integer
  end

  def self.down
    remove_column :items, :imagen_id
    remove_column :products, :imagen_id
  end
end