class SuppliesController < ApplicationController
  before_action :authenticate_user!
  
  def index  
  end
  
  def new
    @supply = Supply.new
  end
  
  def edit  
    @id       = params[:id]
    @supply   = Supply.find_by_id(@id)
  end

  def update  
    @id       = params[:id]
    @supply   = Supply.find_by_id(@id)

    @supply.update(supply_params)

    redirect_to action: "index"    
  end
  
  def create
    @supply = Supply.create(supply_params)    
    redirect_to action: "index"        
  end
  
  def destroy
    @id         = params[:id]    
    @supply     = Supply.find_by_id(@id)

    @supply.destroy

    redirect_to action: "index"    
  end  

  def supply_params
     params.require(:supply).permit(:name, :user_id)    
  end
end

