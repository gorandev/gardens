class RemoveValueFromAlert < ActiveRecord::Migration
  def up
	remove_column :alerts, :value
  end

  def down
  	add_column :alerts, :value, :string
  end
end
