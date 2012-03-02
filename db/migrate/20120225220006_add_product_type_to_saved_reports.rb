class AddProductTypeToSavedReports < ActiveRecord::Migration
  def change
    add_column :saved_reports, :product_type_id, :integer
    add_index :saved_reports, :product_type_id
  end
end
