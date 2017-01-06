class RetailProductsController < ApplicationController
  before_action :authenticate_user!

	def retail_product_params
     params.require(:retail_product).permit(:invoice_id, :product_id, :packages_quantity, :packages_size, :package_price, :user_id, :unit, :expiration_date)
  end  
  
end  