class StocksController < ApplicationController
  before_action :authenticate_user!

  def index
    @stock = Stock.joins("JOIN supplies ON supplies.id = stocks.product_id").select("stocks.id AS stock_id, stocks.packages_quantity AS packages_quantity, stocks.packages_size AS packages_size, stocks.package_price AS package_price, stocks.unit AS unit, stocks.progress AS progress, supplies.name as product_name")
  end
  
  def update
    @id       = params[:id]          
    @stock    = Stock.find_by_id(@id)

    @stock.update(stock_params)

    render :nothing => true
  end  
  
  def destroy
    @id       = params[:id]    
    @stock    = Stock.find_by_id(@id)

    @stock.destroy

    render :nothing => true    
  end

  def stock_params
     params.require(:stock).permit(:id, :progress)
  end  
  
end