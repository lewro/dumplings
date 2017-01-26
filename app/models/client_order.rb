class ClientOrder < ActiveRecord::Base
  has_one :company
  has_many :client_order_products
  accepts_nested_attributes_for :client_order_products
end
