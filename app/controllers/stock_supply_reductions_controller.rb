class StockSupplyReductionsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def create

    #Handle stock preducts object
    @stock_supply_reduction                     = StockSupplyReduction.new
    @stock_supply_reduction.supply_id           = params[:stock_supply_reduction][:supply_id]
    @stock_supply_reduction.user_id             = params[:stock_supply_reduction][:user_id]
    @stock_supply_reduction.reason             = params[:stock_supply_reduction][:reason]
    @stock_supply_reduction.packages_size       = convert_unit(params[:stock_supply_reduction][:unit], params[:stock_supply_reduction][:packages_size])
    @stock_supply_reduction.unit                = standardize_unit(params[:stock_supply_reduction][:unit])
    @stock_supply_reduction.save!

    #Remove supply units from stock
    @stock_products = StockProduct.where(:supply_id => @stock_supply_reduction.supply_id, :unit => @stock_supply_reduction.unit, :gone => false).order(:expiration_date)

    #When supply in the stock
    if @stock_products.size > 0

      @stock_products.each do |stock_product|

        #Is there enought in the current package?
        @sp_size = stock_product.packages_size - @stock_supply_reduction.packages_size

        #When the package is used move to the next one and remove the current one
        if @sp_size < 0 or @sp_size == 0

          stock_product.update(:gone => true, :packages_size => 0)

          #Update the total value so the next package in loop can be updated
          @ps_value_in_smallest_unit = 0 - @sp_size
        else
          #When the package is not used, deduct the values
          stock_product.update(:packages_size => @sp_size)
          #Once the correct product is update stop the loop

        end
      end
    end

    redirect_to action: "index"
  end

  def index
    @stock_supply_reductions = StockSupplyReduction.joins("JOIN users ON users.id = stock_supply_reductions.user_id").joins("JOIN supplies ON stock_supply_reductions.supply_id = supplies.id").where("users.admin_id = #{current_user.admin_id }").select("users.first_name AS first_name, users.last_name AS last_name, supplies.name AS supply_name, stock_supply_reductions.reason AS reason, stock_supply_reductions.created_at AS created_at, stock_supply_reductions.packages_size AS packages_size, stock_supply_reductions.unit AS unit")
  end

  def stock_supply_params
     params.require(:stock_supply_reduction).permit(:supply_id, :product_id, :user_id, :packages_quantity, :packages_size, :package_price, :unit, :reason)
  end
end
