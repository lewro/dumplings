class AddProductCodeToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :product_code, :string
  	add_column :supplies, :product_code, :string
  end
end
