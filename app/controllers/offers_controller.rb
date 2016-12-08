class OffersController < ApplicationController
  before_action :authenticate_user!

  def new
    @offer                          = Offer.new  
    @offer_product                  = OfferProduct.new
  end
  
  def index
    @offers = Offer.joins("JOIN companies ON companies.id = offers.client_id").select('companies.name AS company_name, offers.id AS offer_id, offers.sum AS offer_sum, offers.client_id AS client_id, offers.reference_id AS reference_id, offers.issue_date AS issue_date')    
  end
  
  def edit
    @id                     = params[:id]
    @offer                  = Offer.find_by_id(@id)    
    @client                 = Company.find_by_id(@offer.client_id)        
    @offer_products         = OfferProduct.joins("JOIN offers ON offers.id = offer_products.offer_id JOIN products ON offer_products.product_id = products.id").where("offers.id" => @id).select("offer_products.unit AS unit, offer_products.packages_quantity AS packages_quantity, offer_products.packages_size AS packages_size, offer_products.package_price AS package_price, offer_products.id AS product_id, products.name AS name")
    @offer_product          = OfferProduct.new
    @order_number           = ClientOrder.where(:offer_id => @offer.id).first
    
    @pc = PaymentCondition.find_by_id(@offer.payment_condition)
    
    unless @pc.nil?
      @payment_condition = @pc.text
    end
  end


  def create
    @offer                  = Offer.create(offer_params)    
    @offer_products         = params[:offer][:offerproducts][:offerproduct]

    @offer_products.each do |op|
      unless op[1]["packages_quantity"] == ""
        OfferProduct.create(:product_id => op[1]["product_id"], :packages_quantity => op[1]["packages_quantity"], :packages_size => op[1]["packages_size"], :package_price => op[1]["package_price"],  :unit => op[1]["unit"],  :offer_id => @offer.id, :user_id => current_user.id)
      end
    end
    
    redirect_to action: "index"  
  end
  
  def update
    @id                     = params[:id]          
    @offer                  = Offer.find_by_id(@id)

    @offer.update(offer_params)
        
    redirect_to action: "index"       
  end  


  def destroy
    @id       = params[:id]    
    @offer    = Offer.find_by_id(@id)
    @offer.destroy
    
    #Destroy offer products as well
    @offer_products = OfferProduct.where(:offer_id => @id)
    @offer_products.each do |product|
      product.destroy
    end
    
    redirect_to action: "index"     
  end  

  def offer_params
     params.require(:offer).permit(:client_id, :user_id, :sum, :offerproducts, :note, :reference_id, :issue_date, :payment_condition, :delivery_terms)
  end  
  
end