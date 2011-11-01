class AddImagenToSale < ActiveRecord::Migration
  def change
    add_column :sales, :imagen_id, :integer
  end
end
