class CreateMediaChannelTypes < ActiveRecord::Migration
  def change
    create_table :media_channel_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
