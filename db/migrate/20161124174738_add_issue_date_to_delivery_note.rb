class AddIssueDateToDeliveryNote < ActiveRecord::Migration
  def change
	add_column :delivery_notes, :issue_date, :datetime    	  	
  end
end
