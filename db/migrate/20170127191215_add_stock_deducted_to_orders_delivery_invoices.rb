class AddStockDeductedToOrdersDeliveryInvoices < ActiveRecord::Migration
  def change
      add_column :client_orders, :stock_deducted, :boolean
      add_column :delivery_notes, :stock_deducted, :boolean
      add_column :invoices, :stock_deducted, :boolean
      add_column :retails, :stock_deducted, :boolean
  end
end
