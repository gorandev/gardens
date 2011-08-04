class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :item_id
      t.integer :precio_viejo
      t.integer :precio_nuevo

      t.timestamps
    end
    add_index :events, :item_id
  end

  def self.down
    drop_table :events
  end
end
