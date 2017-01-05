class SupplierOrderProductsController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    @id                       = params[:id] 
    @supplier_order_product   = SupplierOrderProduct.find_by_id(@id)      
    @supplier_order           = SupplierOrder.find_by_id(@supplier_order_product.order_id)
    @new_sum                  = @supplier_order.sum - (@supplier_order_product.package_price * @supplier_order_product.packages_quantity)

    @supplier_order.update(:sum => @new_sum)
        
    @supplier_order_product.destroy  
    
    render :nothing => true 
  end

  def create
    @supplier_order_product   = SupplierOrderProduct.create(supplier_order_product_params)        
    @supplier_order           = SupplierOrder.find_by_id(@supplier_order_product.order_id)
    @new_sum                  = @supplier_order_product.package_price * @supplier_order_product.packages_quantity + @supplier_order.sum

    @supplier_order.update(:sum => @new_sum)
    
    redirect_to "/supplier_orders/#{@supplier_order.id}/edit"
  end

  def supplier_order_product_params
     params.require(:supplier_order_product).permit(:order_id, :supply_id, :packages_quantity, :packages_size, :package_price, :user_id, :unit, :expiration_date)
  end
end