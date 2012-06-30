class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.references :event
      t.string :value
      t.references :rule
      t.references :user

      t.timestamps
    end
    add_index :alerts, :event_id
    add_index :alerts, :rule_id
    add_index :alerts, :user_id
  end
end
