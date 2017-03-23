class StockProduct < ActiveRecord::Base
  belongs_to :stock
  acts_as_indexed :fields => [:id]

  after_save :update_tasks

  def update_tasks
    Task.check_tasks_when_condition_met
  end

end
