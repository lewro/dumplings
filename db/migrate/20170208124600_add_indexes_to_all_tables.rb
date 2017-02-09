class AddIndexesToAllTables < ActiveRecord::Migration
  def change

    add_index(:client_order_products, :product_id)
    add_index(:client_order_products, :order_id)
    add_index(:client_order_products, :user_id)

    add_index(:client_orders, :client_id)
    add_index(:client_orders, :user_id)
    add_index(:client_orders, :offer_id)

    add_index(:companies, :sales_id)
    add_index(:companies, :user_id)

    add_index(:delivery_addresses, :company_id)
    add_index(:delivery_addresses, :user_id)

    add_index(:delivery_note_products, :product_id)
    add_index(:delivery_note_products, :delivery_note_id)
    add_index(:delivery_note_products, :user_id)

    add_index(:delivery_notes, :client_id)
    add_index(:delivery_notes, :user_id)
    add_index(:delivery_notes, :order_id)

    add_index(:events, :user_id)
    add_index(:events, :client_id)

    add_index(:file_uploads, :model_id)
    add_index(:file_uploads, :user_id)

    add_index(:invoice_products, :product_id)
    add_index(:invoice_products, :invoice_id)
    add_index(:invoice_products, :user_id)

    add_index(:invoices, :client_id)
    add_index(:invoices, :user_id)
    add_index(:invoices, :order_id)
    add_index(:invoices, :linked_proforma_id)

    add_index(:offer_products, :product_id)
    add_index(:offer_products, :offer_id)
    add_index(:offer_products, :user_id)

    add_index(:offers, :client_id)
    add_index(:offers, :user_id)

    add_index(:payment_conditions, :user_id)

    add_index(:payments, :invoice_id)
    add_index(:payments, :user_id)

    add_index(:product_supplies, :product_id)
    add_index(:product_supplies, :supply_id)

    add_index(:products, :user_id)
    add_index(:products, :tax_group_id)


    add_index(:retail_products, :product_id)
    add_index(:retail_products, :retail_id)
    add_index(:retail_products, :user_id)

    add_index(:retails, :user_id)

    add_index(:settings, :user_id)

    add_index(:stocks, :supply_id)

    add_index(:supplier_order_products, :supply_id)
    add_index(:supplier_order_products, :order_id)
    add_index(:supplier_order_products, :user_id)

    add_index(:supplier_orders, :supplier_id)
    add_index(:supplier_orders, :user_id)

    add_index(:supplies, :user_id)

    add_index(:tax_groups, :user_id)

  end
end
