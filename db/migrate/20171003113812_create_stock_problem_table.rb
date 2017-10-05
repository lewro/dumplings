class CreateStockProblemTable < ActiveRecord::Migration
  def change
    create_table :stock_problems do |t|

      t.integer :product_id, :null => false
      t.integer :user_id, :null => false
      t.integer :product_stock_location, :null => false

      t.integer :packages_size
      t.integer :unit

      t.text :reason

      t.timestamps
    end

    add_index(:stock_problems, :product_id)
    add_index(:stock_problems, :user_id)
    add_index(:stock_problems, :product_stock_location)

  end
end
