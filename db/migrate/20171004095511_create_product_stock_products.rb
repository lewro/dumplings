class CreateProductStockProducts < ActiveRecord::Migration

  def change
    create_table :product_stock_products do |t|

      t.integer :product_id, :null => false
      t.integer :product_stock_location, :null => false
      t.integer :user_id, :null => false

      t.integer :packages_size
      t.integer :unit

      t.timestamps
    end

    add_index(:product_stock_products, :product_id)
    add_index(:product_stock_products, :user_id)

  end
end
