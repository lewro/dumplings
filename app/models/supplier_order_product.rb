class SupplierOrderProduct < ActiveRecord::Base
  has_many :supplies
  belongs_to :supplier_order
  belongs_to :supplier
end
