class CreateClientOrderProducts < ActiveRecord::Migration
  def change
    create_table :client_order_products do |t|

      t.integer :product_id, :null => false
      t.integer :order_id, :null => false      
      t.integer :user_id, :null => false

      t.integer :packages_quantity
      t.integer :packages_size
      
      t.timestamps
    end
  end
end
