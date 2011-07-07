class AddWordIdToPropertyValues < ActiveRecord::Migration
  def self.up
    add_column :property_values, :word_id, :integer
    add_index :property_values, :word_id
  end

  def self.down
    remove_column :property_values, :word_id
  end
end
