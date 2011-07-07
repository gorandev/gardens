class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :iso_code
      t.string :name
      t.string :status
      t.string :locale
      t.string :decimal_separator
      t.string :thousands_separator
      t.string :time_zone
      t.integer :currency_id

      t.timestamps
    end
    add_index :countries, :currency_id
  end

  def self.down
    drop_table :countries
  end
end
