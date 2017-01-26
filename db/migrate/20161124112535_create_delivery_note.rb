class CreateDeliveryNote < ActiveRecord::Migration
  def change
    create_table :delivery_notes do |t|

      t.integer :client_id, :null => false
      t.integer :user_id, :null => false
      t.integer	:order_id
      t.string :reference_id
      t.decimal :sum
      t.text :note
      t.integer :payment_condition

      t.timestamps
    end
  end
end