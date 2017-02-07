class AddSTockUnitToProducts < ActiveRecord::Migration
  def change
    add_column :products, :unit, :integer
  end
end
