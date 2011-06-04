class AddSourceToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :source, :string
  end

  def self.down
    remove_column :items, :source
  end
end
