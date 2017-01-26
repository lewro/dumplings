class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|

      t.integer :invoice_id, :null => false
      t.integer :user_id, :null => false

      t.decimal :sum
      t.datetime :paid_date

      t.timestamps
    end
  end
end
