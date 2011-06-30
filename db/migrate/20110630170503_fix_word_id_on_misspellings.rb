class FixWordIdOnMisspellings < ActiveRecord::Migration
  def self.up
    change_column :misspellings, :word_id, :integer, :limit => nil
  end

  def self.down
    change_column :misspellings, :word_id, :string
  end
end
