class Retail < ActiveRecord::Base
  has_many :retail_products
  accepts_nested_attributes_for :retail_products
end
