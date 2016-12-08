class DeliveryNote < ActiveRecord::Base
  has_many :delivery_note_products
end
