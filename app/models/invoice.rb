class Invoice < ActiveRecord::Base
  has_many :invoice_products
  accepts_nested_attributes_for :invoice_products

  acts_as_indexed :fields => [:id, :note, :order_id, :reference_id, :sum, :sum_with_tax]
end
