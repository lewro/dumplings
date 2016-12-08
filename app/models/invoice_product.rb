class InvoiceProduct < ActiveRecord::Base
  has_many :products 
  belongs_to :invoice
end
