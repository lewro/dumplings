class AddOfferIdToClientOrder < ActiveRecord::Migration
  def change
    add_column :client_orders, :offer_id, :integer
  end
end
