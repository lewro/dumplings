class CreateProductStockLocation < ActiveRecord::Migration
  def change
    create_table :product_stock_locations do |t|
      t.string    :name, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
  end
end
