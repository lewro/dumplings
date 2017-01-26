class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|

      t.integer :client_id, :null => false
      t.integer :user_id, :null => false

      t.decimal :sum
      t.text :note

      t.timestamps
    end
  end
end
