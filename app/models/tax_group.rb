class TaxGroup < ActiveRecord::Base

  def full_tax
  	"#{id}  - #{tax}%"
  end

end
