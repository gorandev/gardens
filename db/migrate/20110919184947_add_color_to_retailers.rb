class AddColorToRetailers < ActiveRecord::Migration
  def self.up
    add_column :retailers, :color, :string
  end

  def self.down
    remove_column :retailers, :color
  end
end
