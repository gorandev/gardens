class ChangePrice < ActiveRecord::Migration
  def self.up
    change_table :prices do |p|
      p.change :price_date, :datetime
    end
  end

  def self.down
    change_table :prices do |p|
      p.change :price_date, :date
    end
  end
end