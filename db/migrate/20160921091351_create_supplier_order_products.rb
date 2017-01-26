class CreateSupplierOrderProducts < ActiveRecord::Migration
  def change
    create_table :supplier_order_products do |t|

      t.integer :supply_id, :null => false
      t.integer :order_id, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
  end
end
