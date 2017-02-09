class Stock < ActiveRecord::Base
  belongs_to :product
  acts_as_indexed :fields => [:id]
end
