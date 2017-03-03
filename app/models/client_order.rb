class ClientOrder < ActiveRecord::Base
  has_many :client_order_products
  accepts_nested_attributes_for :client_order_products
  acts_as_indexed :fields => [:id, :offer_id, :reference_id, :sum, :note]
end
