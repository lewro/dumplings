class RetailsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

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
      end
    end

    check_stock_update

    redirect_to action: "index"
  end

  def edit
    @id                     = params[:id]
    @retail                 = Retail.find_by_id(@id)
    @retail_product         = RetailProduct.new
    @retail_products        = RetailProduct.joins("JOIN products ON retail_products.product_id = products.id").where(:retail_id => @id).select("retail_products.packages_quantity AS packages_quantity, retail_products.packages_size AS packages_size, retail_products.unit AS packages_unit, retail_products.package_price AS package_price, retail_products.id AS product_id, retail_products.expiration_date AS expiration_date, products.name AS name,  products.unit AS unit, products.product_code AS product_code")

    if @retail.stock_deducted
      @disabled = true
    end

  end

  def check_stock_update
    @products     = RetailProduct.where(:retail_id => @retail.id)
    @time         = Time.now

    update_stock("retail", @retail,  @products, @time)
  end

  def destroy
    @id                      = params[:id]
    @retail                  = Retail.find_by_id(@id)
    @retail_products         = RetailProduct.where(:retail_id => @id)

    revert_stock(@retail_products, "retail", @id)

    @retail.destroy

    @retail_products.each do |product|
      product.destroy
    end

    redirect_to action: "index"
  end


  def retail_params
    params.require(:retail).permit(:user_id, :sum, :transport_cost, :retialproducts, :note, :payment_type, :delivery_type)
  end

end
