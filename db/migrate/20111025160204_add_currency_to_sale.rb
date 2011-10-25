class AddCurrencyToSale < ActiveRecord::Migration
  def change
    add_column :sales, :currency_id, :integer
    add_index :sales, :currency_id
  end
end
