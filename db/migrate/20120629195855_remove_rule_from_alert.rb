class RemoveRuleFromAlert < ActiveRecord::Migration
  def up
  	remove_index :alerts, :rule_id
  	remove_column :alerts, :rule_id
  end

  def down
  	add_column :alerts, :rule_id, :integer
  	add_index :alerts, :rule_id
  end
end
