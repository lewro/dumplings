class AddTaxGroupToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :tax_group_id, :integer
  end
end
