class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|

      t.integer :product_id, :null => false
      t.integer :packages_quantity, :null => false
      t.integer :packages_size, :null => false
      t.integer :package_price, :null => false
      t.integer :unit, :null => false
      t.integer :progress, :null => false, :default => 100

      t.timestamps

    end
  end
end
