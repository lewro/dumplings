class Product < ActiveRecord::Base
  
  has_many :client_order_products

end
