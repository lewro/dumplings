class CreateTasksTable < ActiveRecord::Migration
  def change
    create_table :tasks do |t|

       t.string    :name
       t.text      :message
       t.integer   :condition_object
       t.integer   :operator
       t.integer   :condition_value
       t.integer   :condition_unit
       t.integer   :frequency_value, :default => 1
       t.integer   :status, :default => 0
       t.integer   :user_id

       t.timestamps
    end
  end
end
