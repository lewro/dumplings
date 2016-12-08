class OfferProduct < ActiveRecord::Base    
  has_many :products  
  belongs_to :offer
end
