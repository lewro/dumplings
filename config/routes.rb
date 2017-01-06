Dumplings::Application.routes.draw do
    
  devise_for :users
  root :to => "client_orders#index"

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

  #Resources
  resources :companies
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

  get ":controller(/:action(/:id(.:format)))"    
end
