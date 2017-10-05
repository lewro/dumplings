class RetailsController < ApplicationController
  before_action :authenticate_user!, :except => [:create_from_marketing_site]
  before_action :access_controll, :except => [:create_from_marketing_site]

  skip_before_action :verify_authenticity_token, only: [:create_from_marketing_site]


  def index

    #Filtering
    if params[:retail]

      @from       = params[:retail][:from]
      @to         = params[:retail][:to]

      if @from != ""
        @from_date = "retails.created_at > ?", @from
      else
        @from_date = ""
      end

      if @to != ""
        @to_date = "retails.created_at < ?", @to
      else
        @to_date = ""
      end
    end

    @retails = Retail.paginate(:page => params[:page], :per_page => @pagination).joins("JOIN users on retails.user_id = users.id").where("users.admin_id = #{current_user.admin_id}").order("retails.id DESC").where(@from_date).where(@to_date)
  end

  def new
    @retail                 = Retail.new
    @retail_product         = RetailProduct.new
  end

  def create
    @retail                 = Retail.create(retail_params)
    @retail_products        = params[:retail][:retailproducts][:retailproduct]

    @retail_products.each do |rp|
      unless rp[1]["packages_quantity"] == ""

        RetailProduct.create(:product_id => rp[1]["product_id"], :packages_quantity => rp[1]["packages_quantity"], :packages_size => rp[1]["packages_size"], :package_price => rp[1]["package_price"],  :unit => rp[1]["unit"], :expiration_date => rp[1]["expiration_date"], :retail_id => @retail.id, :user_id => current_user.id)

        #Update  Location Products
        @product_id               = rp[1]["product_id"]
        @packages_quantity        = rp[1]["packages_quantity"]
        @packages_size            = rp[1]["packages_size"]
        @unit                     = rp[1]["unit"]

        @product_stock_location   = params[:retail]["product_stock_location"].to_i

        @product_stock_product    = ProductStockProduct.where(:product_id => @product_id, :unit => @unit, :product_stock_location => @product_stock_location)

        if @product_stock_product.size > 0

          @product_stock_product    = @product_stock_product.first
          @new_package_size         = @product_stock_product.packages_size.to_i - (@packages_quantity.to_i * @packages_size.to_i)

          @product_stock_product.update(:packages_size => @new_package_size)

        else
          #TODO: Error! There should be a product on locatio....!
        end
      end
    end

    check_stock_update

    redirect_to action: "index"
  end



  def destroy
    @id                      = params[:id]
    @retail                  = Retail.find_by_id(@id)
    @retail_products         = RetailProduct.where(:retail_id => @id)

    revert_stock(@retail_products, "retail", @id)

    #Revert Location Products
    @product_stock_location = @retail.product_stock_location

    @retail_products.each do |rp|
      @product_id              = rp.product_id
      @packages_quantity       = rp.packages_quantity
      @packages_size           = rp.packages_size
      @unit                    = rp.unit

      @product_stock_product    = ProductStockProduct.where(:product_id => @product_id, :unit => @unit, :product_stock_location => @product_stock_location)

       if @product_stock_product.size > 0

          @product_stock_product    = @product_stock_product.first
          @new_package_size         = @product_stock_product.packages_size.to_i + (@packages_quantity.to_i * @packages_size.to_i)

          @product_stock_product.update(:packages_size => @new_package_size)

        else
          #TODO: Error! There should be a product on locatio....!
        end
    end

    @retail.destroy

    @retail_products.each do |product|
      product.destroy
    end

    redirect_to action: "index"
  end

  #Only Applies to Dumplings Project
  def create_from_marketing_site

    @retail = Retail.new

    #Dummy Data For Now
    @retail.user_id          = 1
    @retail.payment_type     = 1
    @retail.delivery_type    = 1
    @retail.transport_cost   = 0
    @retail.stock_deducted   = 0

    @retail.customer_name    = params[:customerName]
    @retail.customer_phone   = params[:customerPhone]
    @retail.customer_email   = params[:customerEmail]
    @retail.sum              = params[:totalPrice]

    @retail.save!

    @retail_products         = params[:retails_product]

    @retail_products.each_with_index do |rp, index|

      unless rp[1]["product_name"] == ""

        #1. Find product by name
        @product      = Product.where(:name => rp[1]["product_name"]).first
        @unit         = @product.unit

        RetailProduct.create(:product_id => @product.id, :packages_quantity => 1, :packages_size => rp[1]["packages_quantity"], :package_price => rp[1]["product_price"],  :unit => @unit, :retail_id => @retail.id, :user_id => 1)
      end
    end

    #TODO: Send confirmation email???

    check_stock_update

    render nothing: true
  end

  def edit
    @id                     = params[:id]
    @retail                 = Retail.find_by_id(@id)
    @retail_product         = RetailProduct.new
    @retail_products        = RetailProduct.joins("JOIN products ON retail_products.product_id = products.id").where(:retail_id => @id).select("retail_products.packages_quantity AS packages_quantity, retail_products.packages_size AS packages_size, retail_products.unit AS packages_unit, retail_products.package_price AS package_price, retail_products.id AS product_id, retail_products.expiration_date AS expiration_date, products.name AS name,  products.unit AS unit, products.product_code AS product_code")

    @location               = ProductStockLocation.find_by_id(@retail.product_stock_location).name

    if @retail.stock_deducted
      @disabled = true
    end

  end

  def check_stock_update
    @products     = RetailProduct.where(:retail_id => @retail.id)
    @time         = Time.now

    update_stock("retail", @retail,  @products, @time)
  end



  def retail_params
    params.require(:retail).permit(:user_id, :sum, :transport_cost, :retialproducts, :note, :payment_type, :delivery_type, :product_stock_location)
  end

end
