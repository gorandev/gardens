class ModifySavedReports < ActiveRecord::Migration
  def up
  	add_column :saved_reports, :url, :text
  end

  def down
  	remove_column :saved_reports, :url
  end
end