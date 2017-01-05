class AddExpirationDateToSupplierOrder < ActiveRecord::Migration
  def change
  	add_column :supplier_order_products, :expiration_date, :datetime 
  end
end
