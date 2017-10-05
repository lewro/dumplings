Dumplings::Application.routes.draw do

  devise_for :users
  root :to => "dashboards#index"

  #PDF
  get "offers/pdf"

  #Users
  get "users/settings"

  #Invoices
  post "invoices/mark_invoice_as_paid"
  get "invoices/mark_invoice_as_paid"

  #Client Orders
  post "client_orders/mark_order_as_distributed"
  post "client_orders/mark_order_as_in_progress"

  #Supplier Orders
  post "supplier_orders/mark_order_as_sent"
  post "supplier_orders/mark_order_as_in_stock"

  #Companies
  get "companies/edit_ownership"

  #Settings
  get "settings/edit_settings"

  #File uploads
  post "file_uploads/remove_pdf"
  get "file_uploads/remove_pdf"
  post "file_uploads/remove_af"
  get "file_uploads/remove_af"
  post "file_uploads/email_pdf"

  #Delivery Notes
  get "delivery_notes/delivery_addresses"

  #Stock
  get "stocks/check_product_availability"

  #Retails
  get "retails/create_from_marketing_site"
  post "retails/create_from_marketing_site"

  #Stock problems
  get "stock_problems/new_supplies"

  #Resources
  resources :searches
  resources :companies
  resources :dashboards
  resources :client_orders
  resources :client_order_products
  resources :supplier_orders
  resources :supplier_order_products
  resources :products
  resources :product_supplies
  resources :supplies
  resources :payments
  resources :invoices
  resources :invoice_products
  resources :users
  resources :offers
  resources :offer_products
  resources :stocks
  resources :payment_conditions
  resources :delivery_notes
  resources :delivery_note_products
  resources :file_uploads
  resources :retails
  resources :retail_products
  resources :settings
  resources :dashboards
  resources :events
  resources :delivery_addresses
  resources :tax_groups
  resources :tasks
  resources :stock_problems
  resources :product_stock_locations
  resources :product_stock_products
  resources :stock_supply_reductions

  get ":controller(/:action(/:id(.:format)))"
end
