class DeliveryAddress < ActiveRecord::Base
  belongs_to :company

  def full_address
    "#{street}  #{street_number}, #{zip_code} #{city}"
  end
end
