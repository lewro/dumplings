class CreateTaxGroups < ActiveRecord::Migration
  def change
    create_table :tax_groups do |t|
      t.integer :tax, :null => false
      t.string :user_id, :null => false
      t.text :note
      t.timestamps
    end
  end
end
