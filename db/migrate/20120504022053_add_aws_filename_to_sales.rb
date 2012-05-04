class AddAwsFilenameToSales < ActiveRecord::Migration
  def change
    add_column :sales, :aws_filename, :string
  end
end
