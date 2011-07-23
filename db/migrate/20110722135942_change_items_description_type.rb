class ChangeItemsDescriptionType < ActiveRecord::Migration
  def self.up
    change_table :items do |i|
      i.change :description, :text
    end
  end

  def self.down
    change_table :items do |i|
      p.change :description, :string
    end
  end
end
