class AddStatusToRetail < ActiveRecord::Migration
  def change
    add_column :retails, :status, :integer, :default => 1
  end
end
