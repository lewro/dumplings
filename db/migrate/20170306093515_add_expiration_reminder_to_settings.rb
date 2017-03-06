class AddExpirationReminderToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :expiration_alert, :integer
  end
end
