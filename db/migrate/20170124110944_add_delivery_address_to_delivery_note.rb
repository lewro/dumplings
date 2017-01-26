class AddDeliveryAddressToDeliveryNote < ActiveRecord::Migration
  def change
  	add_column :delivery_notes, :delivery_address_id, :integer
  end
end
