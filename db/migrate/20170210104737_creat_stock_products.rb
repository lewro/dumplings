class CreatStockProducts < ActiveRecord::Migration
  def change
    create_table :stock_products do |t|

      t.integer :supply_id, :null => false
      t.integer :order_id, :null => false

      t.integer :packages_size
      t.decimal :unit_price, :precision => 16, :scale => 10
      t.integer :unit
      t.datetime :expiration_date

      t.timestamps
    end

    add_index(:stock_products, :stock_id)
    add_index(:stock_products, :supply_id)
    add_index(:stock_products, :order_id)

  end
end
