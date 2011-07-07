class CreateRetailers < ActiveRecord::Migration
  def self.up
    create_table :retailers do |t|
      t.string :name
      t.integer :country_id

      t.timestamps
    end
    add_index :retailers, :country_id
  end

  def self.down
    drop_table :retailers
  end
end
