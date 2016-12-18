class CreateDeliveryNoteProducts < ActiveRecord::Migration
  def change
    create_table :delivery_note_products do |t|
      t.integer :product_id, :null => false
      t.integer :delivery_note_id, :null => false      
      t.integer :user_id, :null => false

      t.integer :packages_quantity
      t.integer :packages_size
      
      t.decimal :package_price
      t.string :unit

      t.timestamps
    end
  end
end
