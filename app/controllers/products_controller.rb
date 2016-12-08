class ProductsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def edit  
    @id       = params[:id]
    @product  = Product.find_by_id(@id)
  end

  def update  
    @id       = params[:id]
    @product  = Product.find_by_id(@id)

    @product.update(product_params)

    redirect_to action: "index"    
  end


  def create 
    @product = Product.create(product_params)    

    redirect_to action: "index"        
  end

  def destroy
    @id         = params[:id]    
    @product     = Product.find_by_id(@id)

    @product.destroy
    
    redirect_to action: "index"    
  end  

  def product_params
     params.require(:product).permit(:name, :user_id)    
  end
end

