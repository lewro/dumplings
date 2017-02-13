class StockProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def product_params
     params.require(:stock_product).permit(:order_id, :supply_id, :product_id, :packages_quantity, :packages_size, :package_price, :unit, :expiration_date))
  end
end
