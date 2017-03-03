class CreateTasksTable < ActiveRecord::Migration
  def change
    create_table :tasks do |t|

       t.string    :name
       t.text      :message
       t.string    :condition_object
       t.string    :operator
       t.integer   :condition_value
       t.integer   :condition_unit
       t.integer   :frequency_value
       t.integer   :status
       t.integer   :user_id

       t.timestamps
    end
  end
end
