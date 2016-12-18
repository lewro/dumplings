class ProductSupply < ActiveRecord::Base
  belongs_to :products 
  has_many :supplies
end
