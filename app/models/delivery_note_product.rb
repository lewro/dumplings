class DeliveryNoteProduct < ActiveRecord::Base
  has_many :products 
  belongs_to :delivery_note
  belongs_to :product
end
