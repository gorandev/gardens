class CreateWords < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :words
  end
end
