class SupplierOrder < ActiveRecord::Base
  has_one :company
  has_many :supplier_order_products  
  accepts_nested_attributes_for :supplier_order_products
end
