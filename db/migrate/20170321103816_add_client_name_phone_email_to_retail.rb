class AddClientNamePhoneEmailToRetail < ActiveRecord::Migration
  def change
    add_column :retails, :customer_name, :string
    add_column :retails, :customer_phone, :string
    add_column :retails, :customer_email, :string
  end
end
