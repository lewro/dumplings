class ProductSuppliesController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def destroy
    @id                     = params[:id]
    @product_supply         = ProductSupply.find_by_id(@id)

    @product_supply.destroy

    render :nothing => true
  end

  def create
    @product_supply     = ProductSupply.create(product_supply_params)
    @product_id         = @product_supply.product_id

    redirect_to "/products/#{@product_id}/edit"
  end

  def product_supply_params
     params.require(:product_supply).permit(:supply_id, :product_id, :packages_size, :user_id, :unit)
  end

end
