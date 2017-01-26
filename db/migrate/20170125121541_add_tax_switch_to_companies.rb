class AddTaxSwitchToCompanies < ActiveRecord::Migration
  def change
      add_column :companies, :use_tax, :boolean
  end
end
