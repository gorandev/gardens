class RenameDescripcionToNameInCurrency < ActiveRecord::Migration
  def self.up
    rename_column :currencies, :descripcion, :name
  end

  def self.down
    rename_column :currencies, :name, :descripcion
  end
end
