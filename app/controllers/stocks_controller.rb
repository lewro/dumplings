class StocksController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def index
    @sql = "SELECT SUM(stock_products.packages_size) AS packages_size, stock_products.unit AS unit, supplies.name as product_name, stock_products.supply_id AS supply_id FROM `stock_products` JOIN supplies ON supplies.id = stock_products.supply_id WHERE `stock_products`.`gone` = 0 GROUP BY supplies.id, unit"
    @stock = Supply.find_by_sql @sql

  end

  def edit
    @supply_id = params[:id]
    @unit = params[:unit]

     @sql = "SELECT SUM(stock_products.packages_size) AS packages_size, stock_products.unit AS unit, supplies.name as product_name, stock_products.supply_id AS supply_id FROM stock_products JOIN supplies ON supplies.id = stock_products.supply_id WHERE stock_products.supply_id = " + @supply_id.to_s + " AND stock_products.unit =" + @unit.to_s + " GROUP BY supplies.id"

    @stock = Supply.find_by_sql @sql
    @stock = @stock.first

    @stock_products =  StockProduct.joins("JOIN supplies ON supplies.id = stock_products.supply_id").where(:supply_id => @supply_id, :unit => @unit, :gone => false).select("(stock_products.packages_size * stock_products.unit_price) AS total_price, stock_products.id AS id, stock_products.supply_id AS supply_id, stock_products.packages_size AS packages_size, stock_products.unit AS packages_unit, stock_products.unit_price AS unit_price, stock_products.id AS product_id, stock_products.expiration_date AS expiration_date, stock_products.order_id AS order_id, supplies.name AS name, supplies.product_code AS product_code")
  end

  def check_product_availability
    @product_id             = params[:product_id]
    @unit                   = params[:unit].to_i
    @packages_quantity      = params[:packages_quantity].to_i
    @packages_size          = params[:packages_size].to_i


    #Check if the product - supply connection is defined in the same units as current product
    #if so, get the ration fo the supplies to current product and multiply

    @product_supply = Product.find_by_id(@product_id)

    #When the product unite picked in order is the same as the one defined in the product settings
    if @product_supply.unit == @unit

      @productSupplies = ProductSupply.where(:product_id => @product_id)

      @message             = "<h1>Warning</h1><br/>"
      @message_counter     = 0

      #Go through all the supplies for the current product and calcualate the required size needed based on product size and then compare it with the stock values
      @productSupplies.each do |product_supply|

        product_supply_in_common_unit = convert_unit(product_supply.unit, product_supply.packages_size)

        product_supply_based_in_order = (product_supply_in_common_unit * @packages_quantity) * @packages_size

        @sql = "SELECT SUM(stock_products.packages_size) AS total, supplies.name AS supply_name, stock_products.unit AS unit
          FROM stock_products
          JOIN supplies ON stock_products.supply_id = supplies.id
          WHERE stock_products.supply_id = " + product_supply.supply_id.to_s + "
          GROUP BY stock_products.unit"

        @stock_supply   = StockProduct.find_by_sql @sql

        if @stock_supply.size > 0

          @stock_supply   = @stock_supply.first
          @stock_size     = @stock_supply.total
          @supply_name    = @stock_supply.supply_name
          @supply_unit    = unit(@stock_supply.unit)

          if product_supply_based_in_order > @stock_size
            @message_counter = @message_counter + 1
            @message = @message + "#{t('stock.error')} - " + @supply_name + "<br/>#{t('stock.currently_in_stock')}: " +  @stock_size.to_s + " " + @supply_unit.to_s + "<br/>#{t('stock.your_requirements')}: "  + product_supply_based_in_order.to_s + " " + @supply_unit.to_s
          end
        end
      end

      if @message_counter > 0
        render :text => @message
      else
        render :nothing => true
      end

    else
      render :text => "#{t('unit.mismatch')}"
    end

  end

end
