class AddUserCategory < ActiveRecord::Migration
  def change
    add_column :users, :category, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :note, :text
  end
end
