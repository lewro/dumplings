class AddDeliveryTermsToOffer < ActiveRecord::Migration
  def change
	add_column :offers, :delivery_terms, :text  	
  end
end
