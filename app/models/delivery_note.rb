class DeliveryNote < ActiveRecord::Base
  has_many :delivery_note_products
  accepts_nested_attributes_for :delivery_note_products

  acts_as_indexed :fields => [:id, :order_id, :reference_id, :sum, :note, :contact_person_name, :contact_person_phone ]
end
