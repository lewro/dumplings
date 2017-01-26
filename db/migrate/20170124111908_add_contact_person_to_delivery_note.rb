class AddContactPersonToDeliveryNote < ActiveRecord::Migration
  def change
  	add_column :delivery_notes, :contact_person_name, :string
  	add_column :delivery_notes, :contact_person_phone, :string
  end
end
