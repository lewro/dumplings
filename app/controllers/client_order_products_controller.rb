class ClientOrderProductsController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    @id                     = params[:id]    
    @client_order_product   = ClientOrderProduct.find_by_id(@id)      
    @client_order           = ClientOrder.find_by_id(@client_order_product.order_id)
    @new_sum                = @client_order.sum - (@client_order_product.package_price * @client_order_product.packages_quantity)
    
    @client_order.update(:sum => @new_sum)        
    @client_order_product.destroy  
    
    render :nothing => true 
  end

  def create
    @client_order_product   = ClientOrderProduct.create(client_order_product_params)        
    @client_order           = ClientOrder.find_by_id(@client_order_product.order_id)
    @new_sum                = @client_order_product.package_price * @client_order_product.packages_quantity + @client_order.sum

    @client_order.update(:sum => @new_sum)
    
    redirect_to "/client_orders/#{@client_order.id}/edit"
  end

  def client_order_product_params
     params.require(:client_order_product).permit(:order_id, :product_id, :packages_quantity, :packages_size, :package_price, :user_id, :unit, :expiration_date)
  end

end