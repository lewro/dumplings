class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def index
    @proforma = params[:proforma]
    @pdf_id   = params[:pdf_id]

    if @proforma == 'true'
      @invoices = Invoice.paginate(:page => params[:page], :per_page => @pagination).joins("JOIN companies ON companies.id = invoices.client_id").select("companies.name AS client_name, invoices.id AS id, invoices.sum_with_tax AS sum, invoices.due_date AS due_date, invoices.paid_date AS paid_date, (SELECT SUM(sum) FROM payments WHERE invoices.id = payments.invoice_id) AS balance, (SELECT SUM(sum) FROM payments WHERE payments.invoice_id in (SELECT I2.id FROM invoices AS I2 where I2.linked_proforma_id = invoices.id)) AS proforma_balance").where(:proforma => true).order("id DESC")
    else
      @invoices = Invoice.paginate(:page => params[:page], :per_page => @pagination).joins("JOIN companies ON companies.id = invoices.client_id").select("companies.name AS client_name, invoices.id AS id, invoices.sum_with_tax AS sum, invoices.due_date AS due_date, invoices.paid_date AS paid_date, (SELECT SUM(sum) FROM payments WHERE invoices.id = payments.invoice_id) AS balance, (SELECT SUM(sum) FROM payments WHERE payments.invoice_id = invoices.linked_proforma_id) AS proforma_balance").where(:proforma => false).order("id DESC")
    end
  end

  def new
    @invoice                            = Invoice.new
    @invoice_product                    = InvoiceProduct.new

    #When Creating from ORDER
    if params[:id]
      @order                           = ClientOrder.find_by_id(params[:id])
      @sum                             = 0
      @sum_with_tax                    = 0

      #Proforma already exists, creating invoice
      @proforma = Invoice.where(:order_id => @order.id, :proforma => 1).first

      #If proforma exist
      if @proforma
        @payments                     = Payment.where(:invoice_id => @proforma.id)
        @payments_sum                 = @payments.sum(:sum)
        @proforma_products            = InvoiceProduct.where(:invoice_id => @proforma.id).joins("JOIN products ON invoice_products.product_id = products.id").joins("JOIN tax_groups ON tax_groups.id = products.tax_group_id").select("invoice_products.packages_quantity AS packages_quantity, invoice_products.package_price AS package_price, invoice_products.packages_size AS packages_size, invoice_products.unit AS unit, invoice_products.expiration_date AS expiration_date, invoice_products.product_id AS product_id, tax_groups.tax AS tax")
        @client                       = Company.find_by_id(@proforma.client_id)

        #Proforma exists, get the products from the proforma
        @proforma_products.each do |pp|
          @sum = @sum + (pp.packages_quantity * pp.package_price)
        end

        if @client.use_tax
          @proforma_products.each do |pp|
            @pp_price       = pp.packages_quantity * pp.package_price
            @sum_with_tax   = @sum_with_tax + ((@pp_price / 100) * pp.tax) + @pp_price
          end
        else
          @sum_with_tax = @sum
        end

        @existing_products  = @proforma_products

        #Preset values
        @invoice.order_id             = @proforma.order_id
        @invoice.sum                  = @sum - @payments_sum
        @invoice.sum_with_tax         = @sum_with_tax - @payments_sum
        @invoice.note                 = @proforma.note
        @invoice.reference_id         = @proforma.reference_id
        @invoice.payment_condition    = @proforma.payment_condition
        @invoice.delivery_terms       = @proforma.delivery_terms
        @invoice.client_id            = @proforma.client_id

        @invoice.due_date = Time.now + 30.days

      #If proforma does not exist
      else

        @order_products  = ClientOrderProduct.where(:order_id => @order.id).joins("JOIN products ON client_order_products.product_id = products.id").joins("JOIN tax_groups ON tax_groups.id = products.tax_group_id").select("client_order_products.packages_quantity AS packages_quantity, client_order_products.package_price AS package_price, client_order_products.packages_size AS packages_size, client_order_products.unit AS unit,  client_order_products.expiration_date AS expiration_date, client_order_products.product_id AS product_id, tax_groups.tax AS tax")
        @client          = Company.find_by_id(@order.client_id)

        #Proforma does not exist, get the products from the order
        @order_products.each do |cop|
          @sum = @sum + (cop.packages_quantity * cop.package_price)
        end

        if @client.use_tax
          @order_products.each do |cop|
            @cop_price      = cop.packages_quantity * cop.package_price
            @sum_with_tax   = @sum_with_tax + ((@cop_price / 100) * cop.tax) + @cop_price
          end
        else
          @sum_with_tax = @sum
        end

        @existing_products  = @order_products

        #Preset values
        @invoice.order_id             = @order.id
        @invoice.sum                  = @order.sum
        @invoice.sum_with_tax         = @sum_with_tax
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

      #Delivery note exists
      @delivery_note = DeliveryNote.where(:order_id => @order.id).first
    end

    if @invoice.sum.nil?
      @invoice.sum = 0
    end

    if @invoice.sum_with_tax.nil?
      @invoice.sum_with_tax = 0
    end

    define_balance

    #Creating proforma
    if params[:proforma]
      @invoice.proforma = true
    end
  end

  def create
    @invoice                          = Invoice.create(invoice_params)
    @invoice_products                 = params[:invoice][:invoiceproducts][:invoiceproduct]
    @commit                           = params[:commit]
    @client                           = Company.find(@invoice.client_id)
    @proforma                         = Invoice.where(:order_id => @invoice.id, :proforma => 1).first

    if @proforma
      @invoice.update(:linked_proforma_id => @proforma.id)
    end

    @invoice_products.each do |ip|
      unless ip[1]["packages_quantity"] == ""
        InvoiceProduct.create(:product_id => ip[1]["product_id"], :packages_quantity => ip[1]["packages_quantity"], :packages_size => ip[1]["packages_size"], :package_price => ip[1]["package_price"], :unit => ip[1]["unit"], :expiration_date => ip[1]["expiration_date"], :invoice_id => @invoice.id, :user_id => current_user.id)
      end
    end

    @sum = calculate_total_invoice_sum_without_tax()

    #Calcualate TAX total based on different taxes defined for each product
    if @client.use_tax
      @invoice_sum = calculate_total_invoice_sum_with_tax()
    else
      @invoice_sum = @sum
    end

    @invoice.update(:sum_with_tax => @invoice_sum, :sum => @sum)

    check_stock_update

    #Load Index but aftercall PDF document in new TAB
    if @commit.include? "PDF"
      redirect_to "/invoices/?pdf_id=#{@invoice.id}&proforma=#{@invoice.proforma}"
    else
      redirect_to action: "index", :proforma => @invoice.proforma
    end

  end

  def mark_invoice_as_paid
    @id                               = params[:id]
    @invoice                          = Invoice.find_by_id(@id)
    @time_now                         = Time.now()

    #Get all payments to find out the outstanding value
    #Is proforma?
    if @invoice.proforma
      @proforma                       = @invoice
      @invoice_link                   = Invoice.where(:order_id => @invoice.order_id, :proforma => false).first
    else
      @proforma                        = Invoice.find_by_id(@invoice.linked_proforma_id)
      @invoice_link                    = @invoice
    end

    if @proforma.nil?
      @payments                         = Payment.where(:invoice_id => @invoice_link.id)
    else
      @payments                         = Payment.where(:invoice_id => [@proforma.id, @invoice_link.id])
    end

    @payments_sum                     = @payments.sum(:sum)
    @client                           = Company.find_by_id(@invoice.client_id)
    @invoice_sum                      = @invoice.sum_with_tax
    @current_payment                  = @invoice_sum - @payments_sum
    @payment                          = Payment.create(:invoice_id => @invoice.id, :user_id => current_user.id, :sum => @current_payment, :paid_date => @time_now)

    @invoice.update(:paid_date => @time_now)

    if params[:invoice_edit]
      redirect_to "/invoices/#{@invoice.id}/edit"
    else
      render :nothing => true
    end
  end

  def update
    @id       = params[:id]
    @invoice  = Invoice.find_by_id(@id)
    @commit   = params[:commit]

    @invoice.update(invoice_params)

    check_stock_update

    #Load Index but aftercall PDF document in new TAB
    if @commit.include? "PDF"
      redirect_to "/invoices/?pdf_id=#{@invoice.id}&proforma=#{@invoice.proforma}"
    else
      redirect_to action: "index", :proforma => @invoice.proforma
    end
  end

  def edit
    @id                               = params[:id]
    @invoice                          = Invoice.find_by_id(@id)
    @invoice_products                 = InvoiceProduct.joins("JOIN products ON  invoice_products.product_id = products.id").joins("JOIN tax_groups ON tax_groups.id = products.tax_group_id").where(:invoice_id => @id).select("invoice_products.packages_quantity AS packages_quantity, invoice_products.packages_size AS packages_size, invoice_products.unit AS packages_unit, invoice_products.package_price AS package_price, invoice_products.id AS product_id, invoice_products.expiration_date AS expiration_date, products.name AS name, products.unit AS unit, products.product_code AS product_code, products.tax_group_id AS tax_group_id, tax_groups.tax AS tax")
    @invoice_product                  = InvoiceProduct.new
    @order                            = ClientOrder.find_by_id(@invoice.order_id)
    @client                           = Company.find_by_id(@invoice.client_id)
    @pdfs                             = FileUpload.where(:model => "invoice", :model_id => @id, :user_id => current_user.admin_id)
    @payment_condition                = PaymentCondition.find_by_id(@invoice.payment_condition)

    unless @order.nil?
      @delivery_note  = DeliveryNote.where(:order_id => @order.id).first
    end

    define_balance

    if @invoice.stock_deducted
      @disabled = true
    end
  end

  def pdf
    @id                               = params[:id]
    @invoice                          = Invoice.find_by_id(@id)
    @client                           = Company.find_by_id(@invoice.client_id)
    @ownership                        = Company.where(:category => "ownership", :user_id => current_user.admin_id).last
    @invoice_products                 = InvoiceProduct.joins("JOIN products ON  invoice_products.product_id = products.id").where(:invoice_id => @id).select("invoice_products.packages_quantity AS packages_quantity, invoice_products.packages_size AS packages_size, invoice_products.unit AS unit, invoice_products.package_price AS package_price, invoice_products.id AS product_id, invoice_products.expiration_date AS expiration_date, products.name AS name, products.product_code AS product_code, products.tax_group_id AS tax_group_id ")
    @pc                               = PaymentCondition.find_by_id(@invoice.payment_condition)

    define_balance

    #PDF
    html_string                       = render_to_string(:layout => 'pdf_document')
    kit                               = PDFKit.new(html_string)
    file_unique_name                  = @id.to_s+".pdf"

    if Rails.env.production?
      file_path = "/var/www/sites/dumplings/app/assets/uploads/pdf/" + file_unique_name
    else
      file_path = "#{Rails.root}/app/assets/uploads/pdf/" + file_unique_name
    end

    #File object
    file = kit.to_file(file_path)

    #Create file object, dtb record and upload in folder structure
    PdfFileUpload.upload_pdf_file(file, @invoice.id, @admin_id, "invoice", "document")

    #Remove the tmp file
    FileUtils.rm(file_path)

    render :layout => "pdf_document"
  end

  def define_balance

    #Are we editing proforma invoice?
    if @invoice.proforma == true

      @proforma           = @invoice
      @invoice_sum        = @proforma.sum_with_tax

      #Is the standard invoice linked to this proforma invoice
      @invoice_link = Invoice.where(:order_id => @invoice.order_id, :proforma => false).first

    else
      #We are editing standard invoice
      @invoice_link         = @invoice
      @invoice_sum          = @invoice_link.sum_with_tax

      #Is there proforma invoice linked to this standard invoice
      @proforma = Invoice.find_by_id(@invoice.linked_proforma_id)
    end

    unless @proforma.nil?
      @payments       = Payment.where(:invoice_id => [@proforma.id, @invoice_link.id])
    else
      @payments       = Payment.where(:invoice_id => @invoice_link.id)
    end

    if @payments
      @payments_sum   = @payments.sum(:sum)
      @balance        = @payments_sum - @invoice_sum
    else
      @balance        = 0 - @invoice_sum
    end

    if @invoice_link && (@invoice != @invoice_link)
      @disabled           = true
      @payment_condition  = PaymentCondition.find_by_id(@invoice.payment_condition)
    end
  end

  def destroy
    @id               = params[:id]
    @invoice          = Invoice.find_by_id(@id)
    @invoice_products = InvoiceProduct.where(:invoice_id => @id)

    @invoice.destroy

    @invoice_products.each do |product|
      product.destroy
    end

    redirect_to action: "index"
  end

  def check_stock_update
    @products = InvoiceProduct.where(:invoice_id => @invoice.id)

    if @invoice.taxable_supply_date > Time.now
      #When date is in the future
      @time = @invoice.taxable_supply_date
    else
      @time = Time.now
    end

    update_stock("invoice", @invoice,  @products, @time)
  end

  def invoice_params
     params.require(:invoice).permit(:client_id, :user_id, :sum, :due_date, :paid_date, :order_id, :note, :reference_id, :payment_condition, :delivery_terms, :proforma, :taxable_supply_date, :issue_date, :stock_deducted)
  end

end
