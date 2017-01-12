class ClientOrdersController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @client_order                   = ClientOrder.new                    
    @client_order_product           = ClientOrderProduct.new        
  
    #When order created from existing offer
    if params[:id]
      @offer_id                     = params[:id]
      @offer                        = Offer.find_by_id(@offer_id)
      @offer_products               = OfferProduct.where(:offer_id => @offer_id)
      @sum                          = 0

      @offer_products.each do |op|
        @sum = @sum + (op.packages_quantity * op.package_price)
      end
                
      #Preset values    
      @client_order.offer_id            = @offer_id    
      @client_order.sum                 = @sum
      @client_order.payment_condition   = @offer.payment_condition
      @client_order.note                = @offer.note
      @client_order.reference_id        = @offer.reference_id
      @client_order.delivery_terms      = @offer.delivery_terms
      @client_order.client_id           = @offer.client_id
    end
  end

  def index
    @client_orders  = ClientOrder.joins("JOIN companies ON companies.id = client_orders.client_id").select('companies.name AS company_name, client_orders.id AS order_id, client_orders.sum AS order_sum, client_orders.expected_delivery AS order_expected_delivery, client_orders.distribution AS order_distribution, client_orders.status AS order_status, client_orders.reference_id AS reference_id')
    @pdf_id         = params[:pdf_id]
  end

  def mark_order_as_distributed
    @id                     = params[:id]
    @client_order           = ClientOrder.find_by_id(@id)

    @client_order.update(:distribution => Time.now, :status => 3)

    render :nothing => true    
  end
  
  def mark_order_as_in_progress
    @id                     = params[:id]
    @client_order           = ClientOrder.find_by_id(@id)

    @client_order.update(:status => 2)
    
    render :nothing => true   
  end
  
  def edit
    @id                       = params[:id]
    @client_order             = ClientOrder.find_by_id(@id)
    @client                   = Company.find_by_id(@client_order.client_id)
    @client_order_products    = ClientOrderProduct.joins("JOIN products ON client_order_products.product_id = products.id").where(:order_id => @id).select("client_order_products.packages_quantity AS packages_quantity, client_order_products.packages_size AS packages_size, client_order_products.unit AS packages_unit, client_order_products.package_price AS package_price, client_order_products.id AS product_id, client_order_products.expiration_date AS expiration_date, products.name AS name, products.product_code AS product_code")
    @client_order_product     = ClientOrderProduct.new
    @invoice_number           = Invoice.where(:order_id => @id, :proforma => false).first
    @proforma_invoice_number  = Invoice.where(:order_id => @id, :proforma => true).first
    @delivery_note_number     = DeliveryNote.where(:order_id => @id).first
    @pdfs                     = FileUpload.where(:model => "client_order", :model_id => @id, :user_id => current_user.admin_id)
        
    if @client_order.offer_id
      @offer_id               = Offer.find_by_id(@client_order.offer_id).id
    end

    #Disable editing when these condtions
    if @invoice_number || @proforma_invoice_number || @delivery_note_number

      @disabled = true 

      @payment_condition = PaymentCondition.find_by_id(@client_order.payment_condition)
    end
  end

  def pdf
    @id                     = params[:id]
    @client_order           = ClientOrder.find_by_id(@id)  
    @client                 = Company.find_by_id(@client_order.client_id)     
    @ownership              = Company.where(:category => "ownership", :user_id => current_user.admin_id).last
    @client_order_products  = ClientOrderProduct.joins("JOIN products ON client_order_products.product_id = products.id").where(:order_id => @id).select("client_order_products.packages_quantity AS packages_quantity, client_order_products.packages_size AS packages_size, client_order_products.unit AS 
    unit, client_order_products.package_price AS package_price, client_order_products.id AS product_id, client_order_products.expiration_date AS expiration_date, products.name AS name, products.product_code AS product_code")
    @pc                     = PaymentCondition.find_by_id(@client_order.payment_condition)
    
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
    PdfFileUpload.upload_pdf_file(file, @client_order.id, @admin_id, "client_order", "document")

    #Remove the tmp file
    FileUtils.rm(file_path)

    render :layout => "pdf_document" 
  end  
  
  def update
    @id                     = params[:id]          
    @client_order           = ClientOrder.find_by_id(@id)
    @commit                 = params[:commit]

    @client_order.update(client_order_params)
    
    if params[:client_order][:distribution] != ""
      @client_order.update(:status => 3)
    end
    
    #Load Index but aftercall PDF document in new TAB
    if @commit.include? "PDF"
      redirect_to "/client_orders/?pdf_id=#{@client_order.id}"
    else      
      redirect_to action: "index"  
    end      
  end

  def create
    @client_order           = ClientOrder.create(client_order_params)    
    @client_order_products  = params[:client_order][:clientorderproducts][:clientorderproduct]
    @commit                 = params[:commit]

    @client_order_products.each do |cop|
      unless cop[1]["packages_quantity"] == ""
        ClientOrderProduct.create(:product_id => cop[1]["product_id"], :packages_quantity => cop[1]["packages_quantity"], :packages_size => cop[1]["packages_size"], :package_price => cop[1]["package_price"], :unit => cop[1]["unit"], :expiration_date => cop[1]["expiration_date"], :order_id => @client_order.id, :user_id => current_user.id)
      end
    end
    
    if @commit.include? "PDF"
      redirect_to "/client_orders/?pdf_id=#{@client_order.id}"
    else      
      redirect_to action: "index"  
    end     
  end
  
  def destroy
    @id                     = params[:id]    
    @client_order           = ClientOrder.find_by_id(@id)

    @client_order.destroy
    
    #Destroy client order products as well
    @client_order_products = ClientOrderProduct.where(:order_id => @id)
    
    @client_order_products.each do |product|
      product.destroy
    end
    
    redirect_to action: "index"     
  end  

  def client_order_params
     params.require(:client_order).permit(:client_id, :user_id, :sum, :expected_delivery, :distribution, :status, :clientorderproducts, :note, :offer_id, :reference_id, :order_confirmation, :payment_condition, :delivery_terms)
  end
end
