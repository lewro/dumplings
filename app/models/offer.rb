class Offer < ActiveRecord::Base
  has_many :offer_products
  accepts_nested_attributes_for :offer_products
  acts_as_indexed :fields => [:note, :sum, :reference_id, :id]
end
