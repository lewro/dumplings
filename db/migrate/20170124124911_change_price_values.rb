class ChangePriceValues < ActiveRecord::Migration
  def change
	change_column :client_order_products, :package_price, :decimal, :precision => 16, :scale => 2
	change_column :client_orders, :sum, :decimal, :precision => 16, :scale => 2

	change_column :delivery_note_products, :package_price, :decimal, :precision => 16, :scale => 2
	change_column :delivery_notes, :sum, :decimal, :precision => 16, :scale => 2

	change_column :invoice_products, :package_price, :decimal, :precision => 16, :scale => 2
	change_column :invoices, :sum, :decimal, :precision => 16, :scale => 2

	change_column :offer_products, :package_price, :decimal, :precision => 16, :scale => 2
	change_column :offers, :sum, :decimal, :precision => 16, :scale => 2

	change_column :offer_products, :package_price, :decimal, :precision => 16, :scale => 2
	change_column :offers, :sum, :decimal, :precision => 16, :scale => 2

	change_column :product_supplies	, :package_price, :decimal, :precision => 16, :scale => 2

	change_column :payments, :sum, :decimal, :precision => 16, :scale => 2

	change_column :settings, :tax, :decimal, :precision => 16, :scale => 2

	change_column :retail_products, :package_price, :decimal, :precision => 16, :scale => 2
	change_column :retails, :sum, :decimal, :precision => 16, :scale => 2

	change_column :retail_products, :package_price, :decimal, :precision => 16, :scale => 2
	change_column :retails, :sum, :decimal, :precision => 16, :scale => 2

	change_column :stock_group_products, :package_price, :decimal, :precision => 16, :scale => 2

	change_column :stocks, :package_price, :decimal, :precision => 16, :scale => 2

	change_column :supplier_order_products, :package_price, :decimal, :precision => 16, :scale => 2
	change_column :supplier_orders, :sum, :decimal, :precision => 16, :scale => 2

  end
end
