class InvoicesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @proforma = params[:proforma]
    if @proforma == 'true'
      @invoices = Invoice.joins("JOIN companies ON companies.id = invoices.client_id").select("companies.name AS client_name, invoices.id AS id, invoices.sum AS sum, invoices.due_date AS due_date, invoices.paid_date AS paid_date, (SELECT SUM(sum) FROM payments WHERE invoices.id = payments.invoice_id) AS balance").where(:proforma => true)
    else
      @invoices = Invoice.joins("JOIN companies ON companies.id = invoices.client_id").select("companies.name AS client_name, invoices.id AS id, invoices.sum AS sum, invoices.due_date AS due_date, invoices.paid_date AS paid_date, (SELECT SUM(sum) FROM payments WHERE invoices.id = payments.invoice_id) AS balance").where(:proforma => false)
    end
  end
  
  def new
    @invoice                  = Invoice.new 
    @invoice_product          = InvoiceProduct.new 
  
    #When Creating from ORDER
    if params[:id]
      @order                   = ClientOrder.find_by_id(params[:id])      
      @sum                     = 0

      #Proforma already exists, creating invoice
      @proforma = Invoice.where(:order_id => @order.id, :proforma => 1).first

      #If proforma exist
      if @proforma
        @payments           = Payment.where(:invoice_id => @proforma.id)
        @payments_sum       = @payments.sum(:sum)              
        @proforma_products  = InvoiceProduct.where(:invoice_id => @proforma.id)

        #Proforma exists, get the products from the proforma
        @proforma_products.each do |pp|
          @sum = @sum + (pp.packages_quantity * pp.package_price)
        end

        @existing_products  = @proforma_products

        #Preset values
        @invoice.order_id             = @proforma.order_id
        @invoice.sum                  = @sum - @payments_sum
        @invoice.note                 = @proforma.note
        @invoice.reference_id         = @proforma.reference_id
        @invoice.payment_condition    = @proforma.payment_condition
        @invoice.delivery_terms       = @proforma.delivery_terms
        @invoice.client_id            = @proforma.client_id 

        @invoice.due_date = Time.now + 30.days         

      #If proforma does not exist
      else
        
        @order_products  = ClientOrderProduct.where(:order_id => @order.id)

        #Proforma does not exist, get the products from the order
        @order_products.each do |cop|
          @sum = @sum + (cop.packages_quantity * cop.package_price)
        end

        @existing_products  = @order_products

        #Preset values
        @invoice.order_id             = @order.id
        @invoice.sum                  = @order.sum
        @invoice.note                 = @order.note
        @invoice.reference_id         = @order.reference_id
        @invoice.payment_condition    = @order.payment_condition
        @invoice.delivery_terms       = @order.delivery_terms
        @invoice.client_id            = @order.client_id 

      
        #GET THIS FROM USER SETTINGS!!
        if @order.distribution        
          @invoice.due_date = @order.distribution + 30.days
        else
          @invoice.due_date = Time.now + 30.days 
        end
      end
      
      if @invoice.sum.nil?
        @invoice.sum = 0
      end

      #Delivery note exists
      @delivery_note = DeliveryNote.where(:order_id => @order.id).first
    end
        
    #Creating proforma
    if params[:proforma]
      @invoice.proforma = true      
    end
  end
  
  def create
    @invoice            = Invoice.create(invoice_params)
    @invoice_products   = params[:invoice][:invoiceproducts][:invoiceproduct]

    @invoice_products.each do |ip|
      unless ip[1]["packages_quantity"] == ""
        InvoiceProduct.create(:product_id => ip[1]["product_id"], :packages_quantity => ip[1]["packages_quantity"], :packages_size => ip[1]["packages_size"], :package_price => ip[1]["package_price"], :unit => ip[1]["unit"], :expiration_date => ip[1]["expiration_date"], :invoice_id => @invoice.id, :user_id => current_user.id)
      end
    end

    if @invoice.proforma
      redirect_to action: "index", :proforma => true
    else
      redirect_to action: "index", :proforma => false      
    end
    
  end
  
  def mark_invoice_as_paid
    @id               = params[:id]
    @invoice          = Invoice.find_by_id(@id)
    @time_now         = Time.now()

    @payments         = Payment.where(:invoice_id => @id)
    @payments_sum     = @payments.sum(:sum)        
    @current_payment  = @invoice.sum - @payments_sum    
    @payment          = Payment.create(:invoice_id => @invoice.id, :user_id => current_user.id, :sum => @current_payment, :paid_date => @time_now)
    
    @invoice.update(:paid_date => @time_now)    

    if params[:invoice_edit]
      if @invoice.proforma
        redirect_to action: "index" , :proforma => true
      else
        redirect_to action: "index"
      end
    else
      render :nothing => true
    end
  end
  
  def update
    @id       = params[:id]    
    @invoice  = Invoice.find_by_id(@id)

    @invoice.update(invoice_params)
    
    if @invoice.proforma 
      redirect_to action: "index", :proforma => true
    else
      redirect_to action: "index"
    end
  end

  def edit  
    @id                   = params[:id]
    @invoice              = Invoice.find_by_id(@id)

    @invoice_products     = InvoiceProduct.joins("JOIN products ON  invoice_products.product_id = products.id").where(:invoice_id => @id).select("invoice_products.packages_quantity AS packages_quantity, invoice_products.packages_size AS packages_size, invoice_products.unit AS unit, invoice_products.package_price AS package_price, invoice_products.id AS product_id, invoice_products.expiration_date AS expiration_date, products.name AS name, products.product_code AS product_code ")
    @invoice_product      = InvoiceProduct.new
  
    @order                = ClientOrder.find_by_id(@invoice.order_id)
    @client               = Company.find_by_id(@invoice.client_id)

    unless @order.nil?
      @delivery_note        = DeliveryNote.where(:order_id => @order.id).first
    end

    #Are we editing proforma invoice?
    if @invoice.proforma == true

      @proforma           = @invoice
      @invoice_sum        = @proforma.sum

      #Is the standard invoice linked to this proforma invoice 
      @invoice_link = Invoice.where(:order_id => @invoice.order_id, :proforma => false).first         

  
      # Are there payments linked to standard or proforma invoice?
      @payments_proforma = Payment.where(:invoice_id => @proforma.id)

      if @invoice_link
        @payments_standard = Payment.where(:invoice_id => @invoice_link.id)         
      end  
    else
      #We are editing standard invoice
      @invoice_link = @invoice

      #Is there proforma invoice linked to this standard invoice
      @proforma = Invoice.where(:order_id => @invoice.order_id, :proforma => true).first    
      
      if @proforma
        @payments_proforma  = Payment.where(:invoice_id => @proforma.id)
        @invoice_sum        = @proforma.sum 
      else
        @invoice_sum        = @invoice_link.sum
      end

      @payments_standard  = Payment.where(:invoice_id => @invoice_link.id)       
    end

    #Merge both payments 
    if @payments_proforma
      @payments  = @payments_standard.merge(@payments_proforma)
    else
      @payments  = @payments_standard
    end

    @payments_sum  = @payments.sum(:sum) 
    @balance       = @payments_sum - @invoice_sum
    
    if @invoice_link && (@invoice != @invoice_link)
      @disabled           = true
      @payment_condition  = PaymentCondition.find_by_id(@invoice.payment_condition)
    end

  end
  
  def destroy
    @id       = params[:id]    
    @invoice  = Invoice.find_by_id(@id)
    @invoice.destroy
    
    redirect_to action: "index"         
  end

  def invoice_params
     params.require(:invoice).permit(:client_id, :user_id, :sum, :due_date, :paid_date, :order_id, :note, :reference_id, :payment_condition, :delivery_terms, :proforma, :taxable_supply_date, :issue_date)
  end
end