class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|

      t.string :name, :null => false
      t.string :registration_number, :null => false
      t.string :vat_number
            
      t.string :street
      t.string :street_number
      t.string :city
      t.string :zip_code
      t.string :country

      t.integer :status
      t.string :category      
      t.text :note      

      t.integer :sales_id
      t.integer :user_id
                            
      t.timestamps

    end
  end  
end
