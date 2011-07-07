class CreateProperties < ActiveRecord::Migration
  def self.up
    create_table :properties do |t|
      t.string :name
      t.integer :product_type_id

      t.timestamps
    end
    add_index :properties, :product_type_id
  end

  def self.down
    drop_table :properties
  end
end
