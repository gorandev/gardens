class AddRetailerToMediaChannel < ActiveRecord::Migration
  def change
    add_column :media_channels, :retailer_id, :integer
    add_index :media_channels, :retailer_id
  end
end
