class CreateRetailTable < ActiveRecord::Migration
  def change
    create_table :retails do |t|

      t.integer :user_id, :null => false
      t.integer :payment_type	, :null => false
      t.integer :delivery_type	, :null => false

      t.decimal :sum
      t.decimal :transport_cost
      t.text :note

      t.timestamps

    end
  end
end
