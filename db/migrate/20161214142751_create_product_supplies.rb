class CreateProductSupplies < ActiveRecord::Migration
  def change
    create_table :product_supplies do |t|

      t.integer :product_id, :null => false
      t.integer :supply_id, :null => false
      t.integer :user_id, :null => false

      t.integer :packages_quantity
      t.integer :packages_size
      t.decimal :package_price
      t.integer :unit

      t.timestamps
    end
  end
end
