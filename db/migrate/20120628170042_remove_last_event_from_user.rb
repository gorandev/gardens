class RemoveLastEventFromUser < ActiveRecord::Migration
  def up
  	remove_index :users, :last_event_id
	remove_column :users, :last_event_id
  end

  def down
  	add_column :users, :last_event_id, :integer
    add_index :users, :last_event_id
  end
end
