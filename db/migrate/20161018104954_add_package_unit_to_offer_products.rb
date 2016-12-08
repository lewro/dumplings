class AddPackageUnitToOfferProducts < ActiveRecord::Migration
  def change
    add_column :offer_products, :unit, :integer
    add_column :client_order_products, :unit, :integer

    add_column :supplier_order_products, :packages_quantity, :integer
    add_column :supplier_order_products, :packages_size, :integer
    add_column :supplier_order_products, :package_price, :decimal
    add_column :supplier_order_products, :unit, :integer
  end
end
