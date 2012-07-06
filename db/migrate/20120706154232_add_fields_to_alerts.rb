class AddFieldsToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :product_type_id, :integer
    add_column :alerts, :country_id, :integer
    add_index :alerts, :product_type_id
    add_index :alerts, :country_id
  end
end
