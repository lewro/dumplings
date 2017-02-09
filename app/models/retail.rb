class Retail < ActiveRecord::Base
  has_many :retail_products
  accepts_nested_attributes_for :retail_products
  acts_as_indexed :fields => [:id, :sum, :transport_cost, :note]
end
