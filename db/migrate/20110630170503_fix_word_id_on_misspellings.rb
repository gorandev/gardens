class FixWordIdOnMisspellings < ActiveRecord::Migration
  def self.up
    change_column :misspellings, :word_id, :integer
  end

  def self.down
    change_column :misspellings, :word_id, :string
  end
end
