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
end
