class Product < ActiveRecord::Base
  has_many :client_order_products
  acts_as_indexed :fields => [:id, :name, :user_id, :note, :product_code]

  def product_code_and_name
    unless product_code.nil? || product_code == ""
      "#{product_code} - #{name}"
    else
      "#{name}"
    end
  end
end
