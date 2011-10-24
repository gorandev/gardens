class CreateMediaChannels < ActiveRecord::Migration
  def change
    create_table :media_channels do |t|
      t.string :name
      t.integer :media_channel_type_id

      t.timestamps
    end

    add_index :media_channels, :media_channel_type_id
  end
end
