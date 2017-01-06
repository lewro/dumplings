class RetailProduct < ActiveRecord::Base
  has_many :products
  belongs_to :retail
end
