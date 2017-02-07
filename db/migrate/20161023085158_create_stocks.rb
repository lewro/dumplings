class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|

      t.integer :supply_id, :null => false
      t.integer :packages_size, :null => false
      t.integer :unit, :null => false
      t.timestamps

    end
  end
end
