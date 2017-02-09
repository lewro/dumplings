class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :company

  acts_as_indexed :fields => [:id, :client_id, :note]
end
