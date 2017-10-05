class ProductStockLocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def index
  end

  def new
    @product_stock_location = ProductStockLocation.new()
  end

  def edit
    @id                       = params[:id]
    @product_stock_location   = ProductStockLocation.find_by_id(@id)
    @product_stock_products   = ProductStockProduct.where(:product_stock_location => @id).joins("JOIN products ON product_stock_products.product_id = products.id").select("*", "products.name as product_name")
  end

  def update
    @id                       = params[:id]
    @product_stock_location   = ProductStockLocation.find_by_id(@id)

    @product_stock_location.update(product_stock_location_params)
    redirect_to action: "index"
  end

  def destroy
    @id                        = params[:id]
    @product_stock_location    = ProductStockLocation.find_by_id(@id)
    @product_stock_location.destroy

    redirect_to action: "index"
  end

  def create
    @product_stock_location = ProductStockLocation.create(product_stock_location_params)
    redirect_to action: "index"
  end

  def product_stock_location_params
     params.require(:product_stock_location).permit(:name, :user_id)
  end

end
