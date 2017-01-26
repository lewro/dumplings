class AddOrderConfirmationIdToClientOrder < ActiveRecord::Migration
  def change
	 add_column :client_orders, :order_confirmation, :datetime
  end
end
