class CreatePropertyValues < ActiveRecord::Migration
  def self.up
    create_table :property_values do |t|
      t.string :value
      t.integer :property_id

      t.timestamps
    end
    add_index :property_values, :property_id
  end

  def self.down
    drop_table :property_values
  end
end
