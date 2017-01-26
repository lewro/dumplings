class AddPaymentConditionToClientOrder < ActiveRecord::Migration
  def change
	 add_column :client_orders, :payment_condition, :integer
  end
end
