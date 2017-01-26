class CreateOfferProducts < ActiveRecord::Migration
  def change
    create_table :offer_products do |t|

      t.integer :product_id, :null => false
      t.integer :offer_id, :null => false
      t.integer :user_id, :null => false

      t.integer :packages_quantity
      t.integer :packages_size
      t.decimal :package_price
      t.timestamps

    end
  end
end
