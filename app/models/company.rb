class Company < ActiveRecord::Base
  has_many :client_orders
  validates_presence_of :name, :registration_number

  acts_as_indexed :fields => [:name, :street, :city, :zip_code, :contact_person, :bank, :account_number, :swift_code, :iban_code ]
end
