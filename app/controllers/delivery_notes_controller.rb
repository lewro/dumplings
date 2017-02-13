class DeliveryNotesController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def new
    @delivery_note                  = DeliveryNote.new
    @delivery_note_product          = DeliveryNoteProduct.new

    #When note created from existing order
    if params[:id]
      @order_id                     = params[:id]
      @order                        = ClientOrder.find_by_id(@order_id)
      @order_products               = ClientOrderProduct.where(:order_id => @order_id)
      @client                       = Company.find_by_id(@order.client_id)
      @sum                          = 0
      @delivery_addresses           = DeliveryAddress.where(:company_id => @client.id)

      @order_products.each do |op|
        @sum = @sum + (op.packages_quantity * op.package_price)
      end

      #Preset values
      @delivery_note.order_id            = @order_id
      @delivery_note.sum                 = @sum
      @delivery_note.payment_condition   = @order.payment_condition
      @delivery_note.note                = @order.note
      @delivery_note.reference_id        = @order.reference_id
      @delivery_note.client_id           = @order.client_id
    else
      #Define delivery address for fist client as that is what is displayed in the view as default
      @first_client = @clients.first.id
      @delivery_addresses = DeliveryAddress.where(:company_id => @first_client)
    end

    @invoice        = Invoice.where(:order_id => @order_id, :proforma => false).first
    @proforma       = Invoice.where(:order_id => @order_id, :proforma => true).first
  end

  def index
    @delivery_notes = DeliveryNote.paginate(:page => params[:page], :per_page => @pagination).joins("JOIN users ON users.id = delivery_notes.user_id").joins("JOIN companies ON companies.id = delivery_notes.client_id").where("users.admin_id = #{current_user.admin_id}").select("delivery_notes.reference_id AS reference_id, delivery_notes.order_id AS order_id, delivery_notes.sum AS sum, delivery_notes.note AS note, delivery_notes.payment_condition AS payment_condition, delivery_notes.id AS id, companies.name AS company_name").order("delivery_notes.id DESC")
    @pdf_id         = params[:pdf_id]
  end

  def edit
    @id                       = params[:id]
    @delivery_note            = DeliveryNote.find_by_id(@id)
    @client                   = Company.find_by_id(@delivery_note.client_id)
    @delivery_note_products   = DeliveryNoteProduct.joins("JOIN products ON delivery_note_products.product_id = products.id").where(:delivery_note_id => @id).select("delivery_note_products.packages_quantity AS packages_quantity, delivery_note_products.packages_size AS packages_size, delivery_note_products.unit AS packages_unit, delivery_note_products.package_price AS package_price, delivery_note_products.id AS product_id, delivery_note_products.expiration_date AS expiration_date, products.name AS name,  products.unit AS unit, products.product_code AS product_code")
    @delivery_note_product    = DeliveryNoteProduct.new
    @order_id                 = @delivery_note.order_id
    @invoice                  = Invoice.where(:order_id => @delivery_note.order_id, :proforma => false).first
    @proforma                 = Invoice.where(:order_id => @delivery_note.order_id, :proforma => true).first
    @pdfs                     = FileUpload.where(:model => "delivery_note", :model_id => @id, :user_id => current_user.admin_id)
    @delivery_addresses       = DeliveryAddress.where(:company_id => @client.id)
    @delivery_address         = DeliveryAddress.find_by_id(@delivery_note.delivery_address_id)
    @payment_condition        = PaymentCondition.find_by_id(@delivery_note.payment_condition)

    if @delivery_note.stock_deducted
      @disabled = true
    end
  end

  def delivery_addresses
    @client_id                = params[:id]
    @delivery_note            = DeliveryNote.new
    @delivery_addresses       = DeliveryAddress.where(:company_id => @client_id)
  end

  def pdf
    @id                     = params[:id]
    @delivery_note          = DeliveryNote.find_by_id(@id)
    @client                 = Company.find_by_id(@delivery_note.client_id)
    @ownership              = Company.where(:category => "ownership", :user_id => current_user.admin_id).last
    @delivery_note_products = DeliveryNoteProduct.joins("JOIN products ON delivery_note_products.product_id = products.id").where(:delivery_note_id => @id).select("delivery_note_products.packages_quantity AS packages_quantity, delivery_note_products.packages_size AS packages_size, delivery_note_products.unit AS unit, delivery_note_products.package_price AS package_price, delivery_note_products.id AS product_id, delivery_note_products.expiration_date AS expiration_date, products.name AS name, products.product_code AS product_code")
    @pc                     = PaymentCondition.find_by_id(@delivery_note.payment_condition)
    @delivery_address       = DeliveryAddress.find_by_id(@delivery_note.delivery_address_id)

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
    PdfFileUpload.upload_pdf_file(file, @delivery_note.id, @admin_id, "delivery_note", "document")

    #Remove the tmp file
    FileUtils.rm(file_path)

    render :layout => "pdf_document"
  end

  def create
    @delivery_note            = DeliveryNote.create(delivery_note_params)
    @delivery_note_products   = params[:delivery_note][:deliverynoteproducts][:deliverynoteproduct]
    @commit                   = params[:commit]

    @delivery_note_products.each do |dnp|
      unless dnp[1]["packages_quantity"] == ""
        DeliveryNoteProduct.create(:product_id => dnp[1]["product_id"], :packages_quantity => dnp[1]["packages_quantity"], :packages_size => dnp[1]["packages_size"], :package_price => dnp[1]["package_price"],  :unit => dnp[1]["unit"],  :expiration_date => dnp[1]["expiration_date"], :delivery_note_id => @delivery_note.id, :user_id => current_user.id)
      end
    end

    check_stock_update

    if @commit.include? "PDF"
      redirect_to "/delivery_notes/?pdf_id=#{@delivery_note.id}"
    else
      redirect_to action: "index"
    end
  end

  def update
    @id               = params[:id]
    @delivery_note    = DeliveryNote.find_by_id(@id)
    @commit           = params[:commit]

    @delivery_note.update(delivery_note_params)

    check_stock_update

    #Load Index but aftercall PDF document in new TAB
    if @commit.include? "PDF"
      redirect_to "/delivery_notes/?pdf_id=#{@delivery_note.id}"
    else
      redirect_to action: "index"
    end
  end

  def destroy
    @id                       = params[:id]
    @delivery_note            = DeliveryNote.find_by_id(@id)
    @delivery_note_products   = DeliveryNoteProduct.where(:delivery_note_id => @id)

    @delivery_note.destroy

    @delivery_note_products.each do |product|
      product.destroy
    end

    redirect_to action: "index"
  end

  def check_stock_update
    #Update stock when date in past
    @products = DeliveryNoteProduct.where(:delivery_note_id => @delivery_note.id)

    if @delivery_note.issue_date > Time.now
      @time = @delivery_note.issue_date
    else
      @time = Time.now
    end

    update_stock("delivery_note", @delivery_note,  @products, @time)
  end

  def delivery_note_params
    params.require(:delivery_note).permit(:client_id, :user_id, :order_id, :reference_id, :sum, :note, :payment_condition, :issue_date, :delivery_address_id, :deliverynoteproducts, :contact_person_name, :contact_person_phone, :stock_deducted)
  end
end
