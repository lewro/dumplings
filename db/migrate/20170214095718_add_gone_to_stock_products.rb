class AddGoneToStockProducts < ActiveRecord::Migration
  def change
    add_column :stock_products, :gone, :boolean, :default => false
  end
end
