class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|

      t.integer :client_id, :null => false
      t.integer :user_id, :null => false

      t.decimal :sum

      t.datetime :due_date
      t.datetime :paid_date

      t.timestamps
    end
  end
end
