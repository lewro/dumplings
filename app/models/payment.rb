class Payment < ActiveRecord::Base
  validates_presence_of :sum, :paid_date
  acts_as_indexed :fields => [:id, :invoice_id, :sum]
end
