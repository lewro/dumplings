class AddTaxToSettings < ActiveRecord::Migration
  def change
  	add_column :settings, :tax, :integer
  	add_column :settings, :use_tax, :boolean
  end
end
