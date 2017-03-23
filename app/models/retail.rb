class Retail < ActiveRecord::Base
  has_many :retail_products
  accepts_nested_attributes_for :retail_products
  acts_as_indexed :fields => [:id, :sum, :transport_cost, :note]


  after_save :update_tasks

  def update_tasks
    Task.check_tasks_when_condition_met
  end

end
