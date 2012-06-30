class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.references :alert
      t.references :ruletype
      t.string :value

      t.timestamps
    end
    add_index :rules, :alert_id
    add_index :rules, :ruletype_id
  end
end
