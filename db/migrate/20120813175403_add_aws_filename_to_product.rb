class AddAwsFilenameToProduct < ActiveRecord::Migration
  def change
    add_column :products, :aws_filename, :string
  end
end
