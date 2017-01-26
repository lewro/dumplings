class AddDeliveryTermsToClientOrder < ActiveRecord::Migration
  def change
	 add_column :client_orders, :delivery_terms, :text
  end
end
