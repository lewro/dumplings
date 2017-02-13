class SupplierOrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def index
    @supplier_orders  = SupplierOrder.paginate(:page => params[:page], :per_page => @pagination).joins("JOIN companies ON companies.id = supplier_orders.supplier_id").select("companies.name AS company_name, supplier_orders.id AS order_id, supplier_orders.sum AS order_sum, supplier_orders.expected_delivery AS order_expected_delivery, supplier_orders.delivery AS order_delivery, supplier_orders.status AS order_status ").order("supplier_orders.id DESC")
    @pdf_id           = params[:pdf_id]
  end

  def new
    @supplier_order           = SupplierOrder.new
    @supplier_order_product   = SupplierOrderProduct.new
  end

  def create
    @supplier_order           = SupplierOrder.create(supplier_order_params)
    @supplier_order_products  = params[:supplier_order][:supplierorderproducts][:supplierorderproduct]
    @commit                   = params[:commit]

    @supplier_order_products.each do |sop|
      unless sop[1]["packages_quantity"] == ""
        SupplierOrderProduct.create(:supply_id => sop[1]["supply_id"], :packages_quantity => sop[1]["packages_quantity"], :packages_size => sop[1]["packages_size"], :package_price => sop[1]["package_price"],  :unit => sop[1]["unit"], :expiration_date => sop[1]["expiration_date"],  :order_id => @supplier_order.id, :user_id => current_user.id)
      end
    end

    if params[:supplier_order][:status] == 7
      update_stock(@supplier_order.id)
    end

    if @commit.include? "PDF"
      redirect_to "/supplier_orders/?pdf_id=#{@supplier_order.id}"
    else
      redirect_to action: "index"
    end
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

    update_stock(@id)

    render :nothing => true
  end

  def edit
    @id                       = params[:id]
    @supplier_order           = SupplierOrder.find_by_id(@id)
    @supplier                 = Company.find_by_id(@supplier_order.supplier_id)
    @supplier_order_products  = SupplierOrderProduct.joins("JOIN supplies ON supplies.id = supplier_order_products.supply_id").where(:order_id => @id).select("supplier_order_products.id AS id, supplier_order_products.supply_id AS supply_id, supplier_order_products.packages_quantity AS packages_quantity, supplier_order_products.packages_size AS packages_size, supplier_order_products.unit AS packages_unit, supplier_order_products.package_price AS package_price, supplier_order_products.id AS product_id, supplier_order_products.expiration_date AS expiration_date, supplies.name AS name, supplies.product_code AS product_code")
    @supplier_order_product   = SupplierOrderProduct.new
    @pdfs                     = FileUpload.where(:model => "supplier_order", :model_id => @id, :user_id => current_user.admin_id)
    @disabled                 = false

    if  @supplier_order.status == 6 || @supplier_order.status == 7 || @supplier_order.status == 8
      @disabled = true
    end
  end

  def update
    @id                       = params[:id]
    @supplier_order           = SupplierOrder.find_by_id(@id)
    @commit                   = params[:commit]

    @supplier_order.update(supplier_order_params)

    if params[:supplier_order][:delivery] != ""
      @supplier_order.update(:status => 7)
      update_stock(@id)
    end

    if params[:supplier_order][:status] == 7
      update_stock(@id)
    end

    if @commit.include? "PDF"
      redirect_to "/supplier_orders/?pdf_id=#{@supplier_order.id}"
    else
      redirect_to action: "index"
    end
  end

  def pdf
    @id                       = params[:id]
    @supplier_order           = SupplierOrder.find_by_id(@id)
    @client                   = Company.find_by_id(@supplier_order.supplier_id)
    @ownership                = Company.where(:category => "ownership", :user_id => current_user.admin_id).last
    @supplier_order_products  = SupplierOrderProduct.joins("JOIN supplies ON supplies.id = supplier_order_products.supply_id").where(:order_id => @id).select("supplier_order_products.id AS id, supplier_order_products.supply_id AS supply_id, supplier_order_products.packages_quantity AS packages_quantity, supplier_order_products.packages_size AS packages_size, supplier_order_products.unit AS unit, supplier_order_products.package_price AS package_price, supplier_order_products.id AS product_id, supplier_order_products.expiration_date AS expiration_date, supplies.name AS name, supplies.product_code AS product_code")

    #PDF
    html_string             = render_to_string(:layout => 'pdf_document')
    kit                     = PDFKit.new(html_string)
    file_unique_name        = @id.to_s+".pdf"

    if Rails.env.production?
      file_path = "/var/www/sites/dumplings/app/assets/uploads/pdf/" + file_unique_name
    else
      file_path = "#{Rails.root}/app/assets/uploads/pdf/" + file_unique_name
    end

    #File object
    file = kit.to_file(file_path)

    #Create file object, dtb record and upload in folder structure
    PdfFileUpload.upload_pdf_file(file, @supplier_order.id, @admin_id, "supplier_order", "document")

    #Remove the tmp file
    FileUtils.rm(file_path)

    render :layout => "pdf_document"
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

  def update_stock(id)

    @supplier_order_products  = SupplierOrderProduct.where(:order_id => id)

    @supplier_order_products.each do |product|

      @standard_unit            = standardize_unit(product.unit)
      @product_value            = product.packages_quantity * product.packages_size
      @value_in_smallest_unit   = convert_unit(product.unit, @product_value)
      @stock_products           = Stock.where(:supply_id => product.supply_id)

      #Handle stock object
      if @stock_products.size > 0
        @equal_products = Stock.where(:supply_id => product.supply_id, :unit => @standard_unit)
        if @equal_products.size > 0
          @stock            = @equal_products.first
          @new_size         = @value_in_smallest_unit + @stock.packages_size
          @stock.update(:packages_size => @new_size)
        else
          #When supply product are in the stock but with different unit create them in the stock
          @stock = Stock.create(:supply_id => product.supply_id, :packages_size => @value_in_smallest_unit, :unit => @standard_unit)
        end
      else
        #When the supply products not yet in th stock add them to the stock
        @stock = Stock.create(:supply_id => product.supply_id, :packages_size => @value_in_smallest_unit, :unit => @standard_unit)
      end

      #Handle stock preducts object
      @stockProduct = StockProduct.new

      @stockProduct.stock_id            = @stock.id
      @stockProduct.supply_id           = product.supply_id
      @stockProduct.order_id            = product.order_id
      @stockProduct.packages_quantity   = product.packages_quantity
      @stockProduct.packages_size       = convert_unit(product.unit, product.packages_size)
      @stockProduct.package_price       = product.package_price
      @stockProduct.unit                = @standard_unit
      @stockProduct.expiration_date     = product.expiration_date

      @stockProduct.save!

    end
  end

  def supplier_order_params
     params.require(:supplier_order).permit(:supplier_id, :user_id, :contact_person, :sum, :expected_delivery, :delivery, :status, :supplierorderproducts, :note)
  end
end
