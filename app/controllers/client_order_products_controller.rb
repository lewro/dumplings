class ClientOrderProductsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @id                     = params[:id]
    @client_order_product   = ClientOrderProduct.find_by_id(@id)
    @client_order           = ClientOrder.find_by_id(@client_order_product.order_id)
    @new_sum                = @client_order.sum - (@client_order_product.package_price * @client_order_product.packages_quantity)

    @client_order.update(:sum => @new_sum)
    @client_order_product.destroy

    render :text => "#{t'actions.saved'}"
  end

  def create
    @client_order_product   = ClientOrderProduct.create(client_order_product_params)
    @client_order           = ClientOrder.find_by_id(@client_order_product.order_id)
    @new_sum                = @client_order_product.package_price * @client_order_product.packages_quantity + @client_order.sum

    @client_order.update(:sum => @new_sum)

    redirect_to "/client_orders/#{@client_order.id}/edit"
  end

  def update
    @id                       = params[:id]
    @client_order_product     = ClientOrderProduct.find_by_id(@id)
    @client_order             = ClientOrder.find_by_id(@client_order_product.order_id)
    @client_order_products    = ClientOrderProduct.where(:order_id => @client_order.id)
    @new_sum                  = 0

    @client_order_product.update(client_order_product_params)

    @client_order_products.each do |op|
      @new_sum =  @new_sum  + (op.package_price * op.packages_quantity)
    end

    @client_order.update(:sum => @new_sum)

    render :text => "#{t'actions.saved'}"
  end

  def client_order_product_params
     params.require(:client_order_product).permit(:order_id, :product_id, :packages_quantity, :packages_size, :package_price, :user_id, :unit, :expiration_date)
  end

end