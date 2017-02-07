class AddLinkedProformaToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :linked_proforma_id, :integer
  end
end
