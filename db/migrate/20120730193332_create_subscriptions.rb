class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :id
      t.references :product_type
      t.references :country
      t.references :user

      t.timestamps
    end
    add_index :subscriptions, :product_type_id
    add_index :subscriptions, :country_id
    add_index :subscriptions, :user_id
  end
end
