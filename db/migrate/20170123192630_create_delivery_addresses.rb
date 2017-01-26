class CreateDeliveryAddresses < ActiveRecord::Migration
  def change
    create_table :delivery_addresses do |t|

      t.integer :company_id, :null => false
      t.string :street, :null => false
      t.string :street_number, :null => false
      t.string :city, :null => false
      t.string :zip_code, :null => false
      t.string :country

      t.string :user_id, :null => false
      t.timestamps
    end
  end
end
