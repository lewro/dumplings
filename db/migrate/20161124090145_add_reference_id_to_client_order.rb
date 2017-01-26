class AddReferenceIdToClientOrder < ActiveRecord::Migration
  def change
	 add_column :client_orders, :reference_id, :string
  end
end
