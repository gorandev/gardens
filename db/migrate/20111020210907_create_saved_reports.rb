class CreateSavedReports < ActiveRecord::Migration
  def change
    create_table :saved_reports do |t|
      t.text :querystring
      t.integer :orden
      t.integer :user_id

      t.timestamps
    end
    add_index :saved_reports, :user_id
  end
end
