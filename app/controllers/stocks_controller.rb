class StocksController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def index
    @stock = Stock.paginate(:page => params[:page], :per_page => @pagination).joins("JOIN supplies ON supplies.id = stocks.supply_id").select("stocks.id AS stock_id, stocks.packages_size AS packages_size,  stocks.unit AS unit, supplies.name as product_name").order("stocks.id DESC")
  end

  def update
    @id       = params[:id]
    @stock    = Stock.find_by_id(@id)

    @stock.update(stock_params)

    redirect_to action: "edit"
  end

  def edit
    @id                 = params[:id]
    @stock              = Stock.joins("JOIN supplies ON stocks.supply_id = supplies.id").where(:id => @id).select("supplies.name AS name, stocks.id AS id, stocks.supply_id AS supply_id, stocks.unit AS unit, stocks.packages_size AS packages_size").first

    @stock_products     =  StockProduct.joins("JOIN supplies ON supplies.id = stock_products.supply_id").where(:stock_id => @stock.id).select("stock_products.id AS id, stock_products.supply_id AS supply_id, stock_products.packages_quantity AS packages_quantity, stock_products.packages_size AS packages_size, stock_products.unit AS packages_unit, stock_products.package_price AS package_price, stock_products.id AS product_id, stock_products.expiration_date AS expiration_date, stock_products.order_id AS order_id, supplies.name AS name, supplies.product_code AS product_code")

  end

  def destroy
    @id       = params[:id]
    @stock    = Stock.find_by_id(@id)

    @stock.destroy

    render :nothing => true
  end

  def stock_params
     params.require(:stock).permit(:supply_id, :packages_size, :unit )
  end

end
