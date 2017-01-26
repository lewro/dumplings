class RetailsController < ApplicationController
    before_action :authenticate_user!


    def index
        @retails = Retail.joins("JOIN users on retails.user_id = users.id").where("users.admin_id = #{current_user.admin_id}")
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

        redirect_to action: "index"
    end

    def edit
        @id                     = params[:id]
        @retail                 = Retail.find_by_id(@id)
        @retail_product         = RetailProduct.new
        @retail_products        = RetailProduct.joins("JOIN products ON retail_products.product_id = products.id").where(:retail_id => @id).select("retail_products.packages_quantity AS packages_quantity, retail_products.packages_size AS packages_size, retail_products.unit AS packages_unit, retail_products.package_price AS package_price, retail_products.id AS product_id, retail_products.expiration_date AS expiration_date, products.name AS name, products.product_code AS product_code")
    end

    def retail_params
        params.require(:retail).permit(:user_id, :sum, :transport_cost, :retialproducts, :note, :payment_type, :delivery_type)
    end

end
