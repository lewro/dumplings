class SupplierOrder < ActiveRecord::Base
  has_one :company
  has_many :supplier_order_products
  accepts_nested_attributes_for :supplier_order_products
  acts_as_indexed :fields => [:id, :contact_person, :sum, :note]
end
