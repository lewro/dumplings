class AddLocationToRetail < ActiveRecord::Migration
  def change
    add_column :retails, :product_stock_location, :integer
  end
end
