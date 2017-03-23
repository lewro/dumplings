class SupplierOrder < ActiveRecord::Base
  has_one :company
  has_many :supplier_order_products
  accepts_nested_attributes_for :supplier_order_products
  acts_as_indexed :fields => [:id, :contact_person, :sum, :note]

  after_save :update_tasks

  def update_tasks
    Task.check_tasks_when_condition_met
  end


end
