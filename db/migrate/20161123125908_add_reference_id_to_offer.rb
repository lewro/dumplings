class AddReferenceIdToOffer < ActiveRecord::Migration
  def change
	add_column :offers, :reference_id, :string
	add_column :offers, :issue_date, :datetime
	add_column :offers, :payment_condition, :integer	
  end
end
