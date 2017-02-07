class AddSumWithTaxToInvoice < ActiveRecord::Migration
  def change
      add_column :invoices, :sum_with_tax, :decimal, :precision => 16, :scale => 2
  end
end
