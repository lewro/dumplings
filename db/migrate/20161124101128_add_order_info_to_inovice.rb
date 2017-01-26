class AddOrderInfoToInovice < ActiveRecord::Migration
  def change
  	add_column :invoices, :reference_id, :string
  	add_column :invoices, :payment_condition, :integer
  	add_column :invoices, :delivery_terms, :text
  	add_column :invoices, :proforma, :boolean, :default => false
  end
end
