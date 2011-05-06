class CreateTipoProductos < ActiveRecord::Migration
  def self.up
    create_table :tipo_productos do |t|
      t.string :descripcion

      t.timestamps
    end
  end

  def self.down
    drop_table :tipo_productos
  end
end
