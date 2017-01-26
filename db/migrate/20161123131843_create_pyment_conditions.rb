class CreatePymentConditions < ActiveRecord::Migration
  def change
    create_table :payment_conditions do |t|

      t.string :name, :null => false
      t.integer :user_id, :null => false
      t.text :text

      t.timestamps
    end
  end
end
