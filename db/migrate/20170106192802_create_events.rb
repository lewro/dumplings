class CreateEvents < ActiveRecord::Migration 
  def change
    create_table :events do |t|
      t.integer :user_id, :null => false    
      t.integer :client_id, :null => false          
      t.text :note
      t.date :date
      t.time :time

      t.timestamps  	    	
    end
  end
 end
