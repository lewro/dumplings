class AddBankDetailsToCompany < ActiveRecord::Migration
  def change
  	add_column :companies, :bank, :string
  	add_column :companies, :account_number, :string
  	add_column :companies, :swift_code, :string
  	add_column :companies, :iban_code, :string
  	add_column :companies, :legal, :string
  end
end
