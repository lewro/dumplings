class StockSupplyReduction < ActiveRecord::Migration
  def change
    create_table :stock_supply_reductions do |t|

      t.integer :supply_id, :null => false
      t.integer :packages_size
      t.integer :unit
      t.integer :user_id
      t.text    :reason

      t.timestamps
    end

    add_index(:stock_supply_reductions, :user_id)
    add_index(:stock_supply_reductions, :supply_id)

  end
end
