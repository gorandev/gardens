class CreateMisspellings < ActiveRecord::Migration
  def self.up
    create_table :misspellings do |t|
      t.string :value
      t.integer :word_id

      t.timestamps
    end
    add_index :misspellings, :word_id
  end

  def self.down
    drop_table :misspellings
  end
end
