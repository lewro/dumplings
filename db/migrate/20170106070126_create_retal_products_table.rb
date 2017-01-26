class CreateRetalProductsTable < ActiveRecord::Migration
  def change
    create_table :retail_products do |t|
      t.integer :product_id, :null => false
      t.integer :retail_id, :null => false
      t.integer :user_id, :null => false

      t.integer :packages_quantity
      t.integer :packages_size
      t.decimal :package_price
      t.integer :unit
      t.string :product_code
      t.datetime :expiration_date

      t.timestamps
    end
  end
end
