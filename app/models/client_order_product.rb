class ClientOrderProduct < ActiveRecord::Base
  has_many :products
  belongs_to :client_order
end
