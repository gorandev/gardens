class CreateValorAtributos < ActiveRecord::Migration
  def self.up
    create_table :valor_atributos do |t|
      t.string :descripcion
      t.integer :atributo_id

      t.timestamps
    end
    add_index :valor_atributos, :atributo_id
  end

  def self.down
    drop_table :valor_atributos
  end
end
