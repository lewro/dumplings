class CreateInvoiceProducts < ActiveRecord::Migration
  def change
    create_table :invoice_products do |t|

      t.integer :product_id, :null => false
      t.integer :invoice_id, :null => false
      t.integer :user_id, :null => false

      t.integer :packages_quantity
      t.integer :packages_size
      t.decimal :package_price
      t.integer :unit

      t.timestamps
    end
  end
end
