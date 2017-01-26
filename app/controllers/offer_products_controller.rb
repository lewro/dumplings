class OfferProductsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @id               = params[:id]
    @offer_product    = OfferProduct.find_by_id(@id)
    @offer            = Offer.find_by_id(@offer_product.offer_id)
    @new_sum          = @offer.sum - (@offer_product.package_price * @offer_product.packages_quantity)

    @offer.update(:sum => @new_sum)
    @offer_product.destroy

    render :text => "#{t'actions.saved'}"
  end

  def create
    @offer_product    = OfferProduct.create(offer_product_params)
    @offer            = Offer.find_by_id(@offer_product.offer_id)
    @new_sum          = @offer_product.package_price * @offer_product.packages_quantity + @offer.sum

    @offer.update(:sum => @new_sum)

    redirect_to "/offers/#{@offer.id}/edit"
  end

  def update
    @id               = params[:id]
    @offer_product    = OfferProduct.find_by_id(@id)
    @offer            = Offer.find_by_id(@offer_product.offer_id)
    @offer_products   = OfferProduct.where(:offer_id => @offer.id)
    @new_sum          = 0

    @offer_product.update(offer_product_params)

    @offer_products.each do |op|
      @new_sum =  @new_sum  + (op.package_price * op.packages_quantity)
    end

    @offer.update(:sum => @new_sum)

    render :text => "#{t'actions.saved'}"
  end

  def offer_product_params
     params.require(:offer_product).permit(:offer_id, :product_id, :packages_quantity, :packages_size, :package_price, :user_id, :unit, :expiration_date)
  end

end