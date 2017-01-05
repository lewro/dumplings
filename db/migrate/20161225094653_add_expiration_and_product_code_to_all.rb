class AddExpirationAndProductCodeToAll < ActiveRecord::Migration
  def change  
    add_column :offer_products, :expiration_date, :datetime 
    add_column :client_order_products, :expiration_date, :datetime 
    add_column :delivery_note_products, :expiration_date, :datetime 
    add_column :invoice_products, :expiration_date, :datetime 
    add_column :stock_group_products, :expiration_date, :datetime 
  end
end
