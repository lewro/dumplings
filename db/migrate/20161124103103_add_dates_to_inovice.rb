class AddDatesToInovice < ActiveRecord::Migration
  def change
	add_column :invoices, :issue_date, :datetime    	
	add_column :invoices, :taxable_supply_date, :datetime
  end
end
