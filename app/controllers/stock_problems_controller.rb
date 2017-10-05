class StockProblemsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def create
    @stock_problem         = StockProblem.create(problem_params)
    @product               = Product.find_by_id(@stock_problem.product_id)


    #TODO: SUPPLIES REMOVAL FROM STOCK!!!

    #Update  Location Products
    @product_id               = @stock_problem.product_id
    @packages_size            = @stock_problem.packages_size
    @unit                     = @stock_problem.unit
    @product_stock_location   = @stock_problem.product_stock_location

    @product_stock_product    = ProductStockProduct.where(:product_id => @product_id, :unit => @unit, :product_stock_location => @product_stock_location)

    if @product_stock_product.size > 0

      @product_stock_product    = @product_stock_product.first
      @new_package_size         = @product_stock_product.packages_size.to_i - @packages_size.to_i

      @product_stock_product.update(:packages_size => @new_package_size)

    else
      #TODO: Error! There should be a product on locatio....!
    end


    #Remove from supply stock!
    @product_supplies      = ProductSupply.where(:product_id => @product.id)

    @product_supplies.each do |product_supply|

      #Convert the unit to the standrd unit (the smallest)
      @standard_unit          = standardize_unit(product_supply.unit)

      @product_supply_value = product_supply.packages_size * (@stock_problem.packages_size)

      #Convert the values to the smallest unit
      @ps_value_in_smallest_unit = convert_unit(product_supply.unit, @product_supply_value)

      #Remove supply units from stock
      @stock_products = StockProduct.where(:supply_id => product_supply.supply_id, :unit => @standard_unit, :gone => false).order(:expiration_date)

        #When supply in the stock
      if @stock_products.size > 0

        @stock_products.each do |stock_product|

          #Is there enought in the current package?
          @sp_size = stock_product.packages_size - @ps_value_in_smallest_unit

          #When the package is used move to the next one and remove the current one
          if @sp_size < 0 or @sp_size == 0
            #Record the action in the stop_product_reduction table
            record_stock_product_reduction(stock_product, "stock_problem", @stock_problem.id, stock_product.packages_size)
            stock_product.update(:gone => true, :packages_size => 0)

            #Update the total value so the next package in loop can be updated
            @ps_value_in_smallest_unit = 0 - @sp_size
          else
            #When the package is not used, deduct the values
            stock_product.update(:packages_size => @sp_size)
            #Once the correct product is update stop the loop

            #Record the action in the stop_product_reduction table
            record_stock_product_reduction(stock_product, "stock_problem", @stock_problem.id, @ps_value_in_smallest_unit)
          end
        end
      else
        #Supply not in stock?
        #TODO: SEND EMAIL ?
      end
    end



    redirect_to action: "index"
  end

  def index

  end

  def new
    @stock_problem = StockProblem.new
  end

  def new_supplies
    @stock_supply_reduction = StockSupplyReduction.new
  end

  def problem_params
     params.require(:stock_problem).permit(:product_id, :user_id, :packages_size, :unit, :reason, :product_stock_location)
  end
end
