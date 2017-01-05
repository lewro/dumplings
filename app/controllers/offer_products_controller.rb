class OfferProductsController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    @id               = params[:id]        
    @offer_product    = OfferProduct.find_by_id(@id)      
    @offer            = Offer.find_by_id(@offer_product.offer_id)
    @new_sum          = @offer.sum - (@offer_product.package_price * @offer_product.packages_quantity)

    @offer.update(:sum => @new_sum)        
    @offer_product.destroy  
    
    render :nothing => true 
  end

  def create
    @offer_product    = OfferProduct.create(offer_product_params)        
    @offer            = Offer.find_by_id(@offer_product.offer_id)
    @new_sum          = @offer_product.package_price * @offer_product.packages_quantity + @offer.sum

    @offer.update(:sum => @new_sum)
    
    redirect_to "/offers/#{@offer.id}/edit"
  end

  def offer_product_params
     params.require(:offer_product).permit(:offer_id, :product_id, :packages_quantity, :packages_size, :package_price, :user_id, :unit, :expiration_date)
  end
  
end