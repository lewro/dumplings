class AddPackagePriceToClientOrderProducts < ActiveRecord::Migration
  def change
    add_column :client_order_products, :package_price, :decimal
  end
end
