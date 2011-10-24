class AddCountryToMediaChannels < ActiveRecord::Migration
  def change
    add_column :media_channels, :country_id, :integer
    add_index :media_channels, :country_id
  end
end
