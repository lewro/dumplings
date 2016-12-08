class CreateClientOrders < ActiveRecord::Migration
  def change
    create_table :client_orders do |t|

      t.integer :client_id, :null => false
      t.integer :user_id, :null => false
      
      t.string :expected_delivery
      t.datetime :distribution
                  
      t.decimal :sum 

      t.text :note
      t.integer :status
            
      t.timestamps
    end
  end
end
