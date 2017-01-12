class CreateSettingsTable < ActiveRecord::Migration
  def change
    create_table :settings do |t|

			t.integer :user_id, :null => false      
      t.integer :id_format
      t.string :currency

      t.timestamps  	    	
    end
  end
end
