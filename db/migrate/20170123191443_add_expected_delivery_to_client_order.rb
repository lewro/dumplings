class AddExpectedDeliveryToClientOrder < ActiveRecord::Migration
  def change
  	add_column :client_orders, :expected_delivery, :datetime
  end
end
