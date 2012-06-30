class FixRuleTypeinRules < ActiveRecord::Migration
  def up
  	remove_index :rules, :ruletype_id
  	remove_column :rules, :ruletype_id
	add_column :rules, :rule_type_id, :integer
    add_index :rules, :rule_type_id
  end

  def down
  	remove_index :rules, :rule_type_id
  	remove_column :rules, :rule_type_id
  	add_column :rules, :ruletype_id, :references
  	add_index :rules, :ruletype_id
  end
end
