class AddPageToSales < ActiveRecord::Migration
  def change
    add_column :sales, :page, :integer
  end
end
