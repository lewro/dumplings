class CreatStockProducts < ActiveRecord::Migration
  def change
    create_table :stock_products do |t|

      t.integer :stock_id, :null => false
      t.integer :supply_id, :null => false
      t.integer :order_id, :null => false
      t.integer :packages_quantity
      t.integer :packages_size
      t.decimal :package_price
      t.integer :unit
      t.datetime :expiration_date

      t.timestamps
    end

    add_index(:stock_products, :stock_id)
    add_index(:stock_products, :supply_id)
    add_index(:stock_products, :order_id)

  end
end
