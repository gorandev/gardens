class CreateAtributos < ActiveRecord::Migration
  def self.up
    create_table :atributos do |t|
      t.string :descripcion
      t.integer :tipo_producto_id

      t.timestamps
    end
    add_index :atributos, :tipo_producto_id
  end

  def self.down
    drop_table :atributos
  end
end
