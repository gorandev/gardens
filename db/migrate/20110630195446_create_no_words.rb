class CreateNoWords < ActiveRecord::Migration
  def self.up
    create_table :no_words do |t|
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :no_words
  end
end
