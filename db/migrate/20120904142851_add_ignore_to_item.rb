class AddIgnoreToItem < ActiveRecord::Migration
  def change
    add_column :items, :ignored, :boolean
  end
end
