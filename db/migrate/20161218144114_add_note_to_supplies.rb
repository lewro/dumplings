class AddNoteToSupplies < ActiveRecord::Migration
  def change
  	add_column :supplies, :note, :text
  end
end
