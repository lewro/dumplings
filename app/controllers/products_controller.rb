class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def index
  end

  def new
    @product            = Product.new
    @product_supply     = ProductSupply.new
  end

  def edit
    @id                 = params[:id]
    @product            = Product.find_by_id(@id)
    @product_supplies   = ProductSupply.joins("JOIN supplies ON supplies.id = product_supplies.supply_id").where(:product_id => @product.id).select("supplies.name AS name, supplies.product_code AS product_code, product_supplies.product_id AS product_id, product_supplies.id AS product_supply_id, product_supplies.supply_id AS supply_id, product_supplies.packages_size as packages_size,  product_supplies.unit AS unit")
    @product_supply     = ProductSupply.new
  end

  def update
    @id       = params[:id]
    @product  = Product.find_by_id(@id)

    @product.update(product_params)

    redirect_to action: "index"
  end

  def create
    @product             = Product.create(product_params)
    @product_supplies    = params[:product][:productsupplies][:productsupply]

    @product_supplies.each do |ps|
      unless ps[1]["packages_quantity"] == ""
        ProductSupply.create(:product_id => @product.id, :packages_quantity => ps[1]["packages_quantity"], :packages_size => ps[1]["packages_size"], :package_price => ps[1]["package_price"],  :unit => ps[1]["unit"],  :supply_id => ps[1]["supply_id"], :user_id => current_user.id)
      end
    end

    redirect_to action: "index"
  end

  def destroy
    @id           = params[:id]
    @product      = Product.find_by_id(@id)

    @product.destroy

    redirect_to action: "index"
  end

  def product_params
     params.require(:product).permit(:name, :user_id, :note, :product_code, :tax_group_id, :unit)
  end
end

