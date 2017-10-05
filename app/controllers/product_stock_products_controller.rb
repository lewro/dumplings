class ProductStockProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def index
  end

  def new
    @location                = params[:location].to_i
    @product_stock_product   = ProductStockProduct.new()
  end

  def edit
    @id                      = params[:id]
    @product_stock_product   = ProductStockProduct.find_by_id(@id)
  end

  def update
    @id                       = params[:id]
    @product_stock_product    = ProductStockProduct.find_by_id(@id)

    @product_stock_product.update(product_stock_product_params)
    redirect_to action: "index"
  end

  def destroy
    @id                        = params[:id]
    @product_stock_product    = ProductStockProduct.find_by_id(@id)
    @product_stock_product.destroy

    redirect_to action: "index"
  end

  def create
    @product_id                 = params[:product_stock_product][:product_id]
    @product_stock_location     = params[:product_stock_product][:product_stock_location]
    @unit                       = params[:product_stock_product][:unit]
    @packages_size              = params[:product_stock_product][:packages_size].to_i

    # If the product and unit exist update the existing one!
    @product_stock_products = ProductStockProduct.where(:product_id => @product_id, :product_stock_location => @product_stock_location, :unit => @unit)

    if @product_stock_products.size > 0
      @product_stock_product    = @product_stock_products.first
      @current_size             = @product_stock_product.packages_size

      @product_stock_product.update(:packages_size => @current_size + @packages_size)
    else

      @product_stock_product   = ProductStockProduct.create(product_stock_product_params)
    end

    @location                = @product_stock_product.product_stock_location

    redirect_to "/product_stock_locations/#{@location}/edit"
  end

  def product_stock_product_params
     params.require(:product_stock_product).permit(:product_id, :user_id, :product_stock_location, :packages_size, :unit)
  end

end
