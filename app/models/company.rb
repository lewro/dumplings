class Company < ActiveRecord::Base
  has_many :client_orders  
  validates_presence_of :name, :registration_number
end
