class AddLastEventToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_event_id, :integer
    add_index :users, :last_event_id
  end
end
