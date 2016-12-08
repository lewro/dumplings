class Payment < ActiveRecord::Base
  validates_presence_of :invoice_id, :sum, :paid_date
end
