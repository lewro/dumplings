class StockProduct < ActiveRecord::Base
  belongs_to :stock
  acts_as_indexed :fields => [:id]
end
