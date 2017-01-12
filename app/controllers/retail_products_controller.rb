class RetailProductsController < ApplicationController
  before_action :authenticate_user!


  def destroy
    @id               = params[:id]        
    @retail_product   = RetailProduct.find_by_id(@id)      
    @retail           = Retail.find_by_id(@retail_product.retail_id)
    @new_sum          = @retail.sum - (@retail_product.package_price * @retail_product.packages_quantity)

    @retail.update(:sum => @new_sum)        
    @retail_product.destroy  
    
    render :nothing => true 
  end

  def create
    @retail_product   	= RetailProduct.create(retail_product_params)        
    @retail           	= Retail.find_by_id(@retail_product.retail_id)
    @new_sum          	= @retail_product.package_price * @retail_product.packages_quantity + @retail.sum

    @retail.update(:sum => @new_sum)
    
    redirect_to "/retails/#{@retail.id}/edit"
  end

	def retail_product_params
     params.require(:retail_product).permit(:retail_id, :product_id, :packages_quantity, :packages_size, :package_price, :user_id, :unit, :expiration_date, :product_code)
  end  
  
end  