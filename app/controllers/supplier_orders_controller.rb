class SupplierOrdersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @supplier_orders = SupplierOrder.joins("JOIN companies ON companies.id = supplier_orders.supplier_id").select("companies.name AS company_name, supplier_orders.id AS order_id, supplier_orders.sum AS order_sum, supplier_orders.expected_delivery AS order_expected_delivery, supplier_orders.delivery AS order_delivery, supplier_orders.status AS order_status ")
  end

  def new
    @supplier_order           = SupplierOrder.new
    @supplier_order_product   = SupplierOrderProduct.new
  end
  
  def create
    @supplier_order           = SupplierOrder.create(supplier_order_params)    
    @supplier_order_products  = params[:supplier_order][:supplierorderproducts][:supplierorderproduct]

    @supplier_order_products.each do |sop|
      unless sop[1]["packages_quantity"] == ""
        SupplierOrderProduct.create(:supply_id => sop[1]["supply_id"], :packages_quantity => sop[1]["packages_quantity"], :packages_size => sop[1]["packages_size"], :package_price => sop[1]["package_price"],  :unit => sop[1]["unit"], :expiration_date => sop[1]["expiration_date"],  :order_id => @supplier_order.id, :user_id => current_user.id)
      end
    end
    
    redirect_to action: "index"  
  end  
  
  def mark_order_as_sent
    @id                     = params[:id]
    @supplier_order         = SupplierOrder.find_by_id(@id)

    @supplier_order.update(:delivery => Time.now, :status => 6)
    render :nothing => true    
  end
  
  def mark_order_as_in_stock
    @id                       = params[:id]
    @supplier_order           = SupplierOrder.find_by_id(@id)

    @supplier_order.update(:status => 7, :delivery => Time.now)
            
    updateStock(@id)
    
    render :nothing => true   
  end
    
  def edit
    @id                       = params[:id]
    @supplier_order           = SupplierOrder.find_by_id(@id)
    @supplier                 = Company.find_by_id(@supplier_order.supplier_id)
    @supplier_order_products  = SupplierOrderProduct.joins("JOIN supplies ON supplies.id = supplier_order_products.supply_id").where(:order_id => @id).select("supplier_order_products.id AS id, supplier_order_products.supply_id AS supply_id, supplier_order_products.packages_quantity AS packages_quantity, supplier_order_products.packages_size AS packages_size, supplier_order_products.unit AS packages_unit, supplier_order_products.package_price AS package_price, supplier_order_products.id AS product_id, supplier_order_products.expiration_date AS expiration_date, supplies.name AS name, supplies.product_code AS product_code")
    @supplier_order_product   = SupplierOrderProduct.new
    @order_disabled           = false
    
    if  @supplier_order.status == 6 || @supplier_order.status == 7 || @supplier_order.status == 8
      @order_disabled = true
    end
  end
  
  def update
    @id                     = params[:id]          
    @supplier_order         = SupplierOrder.find_by_id(@id)

    @supplier_order.update(supplier_order_params)
    
    if params[:supplier_order][:delivery] != ""
      @supplier_order.update(:status => 7)
      updateStock(@id)      
    end
    
    if params[:supplier_order][:status] == 7
      updateStock(@id)
    end
    
    redirect_to action: "index"       
  end  
  
  def destroy
    @id                       = params[:id]    
    @supplier_order           = SupplierOrder.find_by_id(@id)

    @supplier_order.destroy
    
    #Destroy client order products as well
    @supplier_order_products = SupplierOrderProduct.where(:order_id => @id)
    @supplier_order_products.each do |product|
      product.destroy
    end
    
    redirect_to action: "index"     
  end  
  
  def updateStock(id)
    @supplier_order_products  = SupplierOrderProduct.where(:order_id => id)    
    
    @supplier_order_products.each do |product|      

      @stock_products = Stock.where(:product_id => product.supply_id)

      if @stock_products.size > 0        
              
        @equal_products = Stock.where(:product_id => product.supply_id, :unit => product.unit, :package_price => product.package_price)        
        @equal_product = @equal_products.first

        if @equal_products.size > 0
          @equal_product.update(:packages_quantity => product.packages_quantity + @equal_product.packages_quantity, :progress => 100)        
        else
          Stock.create(:product_id => product.supply_id, :packages_quantity => product.packages_quantity, :packages_size => product.packages_size ,:package_price => product.package_price, :unit => product.unit)
        end
      else
        Stock.create(:product_id => product.supply_id, :packages_quantity => product.packages_quantity, :packages_size => product.packages_size ,:package_price => product.package_price, :unit => product.unit)        
      end
    end   
  end
    
  def supplier_order_params
     params.require(:supplier_order).permit(:supplier_id, :user_id, :contact_person, :sum, :expected_delivery, :delivery, :status, :supplierorderproducts, :note)
  end  
end
