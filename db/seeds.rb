# Products
@products = Product.all
@products.each do |product|
  product.destroy
end
Product.create(:name => 'Chicken dumplings', :user_id => 1)
Product.create(:name => 'Vegetable dumplings', :user_id => 1)


# Supplies
@supplies = Supply.all
@supplies.each do |supply|
  supply.destroy
end
Supply.create(:name => 'Chicken fillings', :user_id => 1)
Supply.create(:name => 'Vegetable fillings', :user_id => 1)
Supply.create(:name => 'Packaging foil 100m', :user_id => 1)

# Companies
@companies = Company.all
@companies.each do |company|
  company.destroy
end
Company.create(:id => 1, :name => 'Potrefena husa', :registration_number => 2232321313, :vat_number => 423423434, :street => "Narodni", :street_number => 233, :city => "Praha", :zip_code => "110 10", :country => "CZ", :status => 1, :category => "client", :note => "My first note", :user_id => 1, :sales_id => 1)
Company.create(:id => 2, :name => 'Hotel Hilton', :registration_number => 555555435, :vat_number => 23435352, :street => "Parizska", :street_number => 24, :city => "Praha", :zip_code => "110 10", :country => "CZ", :status => 1, :category => "client", :note => "My first note", :user_id => 1, :sales_id => 1)

# Client orders
@client_orders = ClientOrder.all
@client_orders.each do |c_order|
  c_order.destroy
end
ClientOrder.create(:client_id => 1, :sales_id => 1, :user_id => 1, :expected_delivery => "2015-11-09 10:55:45", :distribution => "", :sum => "2000", :currency => "CZK", :note => "Client order note", :status => 1)
ClientOrder.create(:client_id => 2, :sales_id => 1, :user_id => 1, :expected_delivery => "2015-11-09 10:55:45", :distribution => "", :sum => "5000", :currency => "CZK", :note => "Client order note", :status => 1)


# Supplier orders
@supplier_orders = SupplierOrder.all
@supplier_orders.each do |s_order|
  s_order.destroy
end
SupplierOrder.create(:supplier_id => 2, :contact_person => "Mark Hudson", :user_id => 1, :expected_delivery => "2015-11-09 10:55:45", :delivery => "", :sum => "100", :currency => "CZK", :note => "Supplier order note", :status => "In progress")

# Invoices
@invoices = Invoice.all
@invoices.each do |invoice|
  invoice.destroy
end
Invoice.create(:client_id => 1, :user_id => 1, :sum => 2000, :currency => "CZK", :due_date => "2015-11-09 10:55:45", :paid_date => "")

# Payments
@payments = Payment.all
@payments.each do |payment|
  payment.destroy
end
Payment.create(:invoice_id => 1, :user_id => 1, :sum => 300, :currency => "CZK",  :paid_date => "2015-11-09 10:55:45")



