class CreateSupplierOrders < ActiveRecord::Migration
  def change
    create_table :supplier_orders do |t|

      t.integer :supplier_id, :null => false
      t.integer :user_id, :null => false

      t.string :contact_person

      t.datetime :expected_delivery
      t.datetime :delivery

      t.decimal :sum

      t.text :note
      t.integer :status

      t.timestamps
    end
  end
end