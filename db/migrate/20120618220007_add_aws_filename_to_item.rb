class AddAwsFilenameToItem < ActiveRecord::Migration
  def change
    add_column :items, :aws_filename, :string
  end
end
