class CreateStockProductReductions < ActiveRecord::Migration
  def change
    create_table :stock_product_reductions do |t|

       t.integer   :stock_product_id, :null => false
       t.string    :actual_model_name
       t.integer   :actual_model_id
       t.integer   :user_id
       t.integer   :packages_size

       t.timestamps
    end
  end
end
