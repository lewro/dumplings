class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def new
    @offer                          = Offer.new
    @offer_product                  = OfferProduct.new
  end

  def index

    @pdf_id        = params[:pdf_id]

    #Filtering
    if params[:offer]

      @client_id  = params[:offer][:client_id].to_i
      @from       = params[:offer][:from]
      @to         = params[:offer][:to]

      if @client_id > 0
        @client = "offers.client_id = ?", @client_id
      else
        @client = "offers.client_id > ?", 0
      end

      if @from != ""
        @from_date = "issue_date > ?", @from
      else
        @from_date = ""
      end

      if @to != ""
        @to_date = "issue_date < ?", @to
      else
        @to_date = ""
      end
    end

    @offers = Offer.paginate(:page => params[:page], :per_page => @pagination).joins("JOIN companies ON companies.id = offers.client_id").select('companies.name AS company_name, offers.id AS offer_id, offers.sum AS offer_sum, offers.client_id AS client_id, offers.reference_id AS reference_id, offers.issue_date AS issue_date').order("offers.id DESC").where(@client).where(@from_date).where(@to_date)

  end

  def edit
    @id                     = params[:id]
    @offer                  = Offer.find_by_id(@id)
    @client                 = Company.find_by_id(@offer.client_id)
    @offer_products         = OfferProduct.joins("JOIN offers ON offers.id = offer_products.offer_id JOIN products ON offer_products.product_id = products.id").where("offers.id" => @id).select("offer_products.unit AS packages_unit, offer_products.packages_quantity AS packages_quantity, offer_products.packages_size AS packages_size, offer_products.package_price AS package_price, offer_products.id AS product_id, offer_products.expiration_date AS expiration_date, products.name AS name,  products.unit AS unit, products.product_code AS product_code")
    @offer_product          = OfferProduct.new
    @order_number           = ClientOrder.where(:offer_id => @offer.id).first
    @pc                     = PaymentCondition.find_by_id(@offer.payment_condition)
    @pdfs                   = FileUpload.where(:model => "offer", :model_id => @id, :user_id => current_user.admin_id)

    unless @pc.nil?
      @payment_condition = @pc.text
    end

    #Disable editing when these linked objects aleady exist
    if @order_number
      @disabled = true
    end
  end

  def pdf
    @id                     = params[:id]
    @offer                  = Offer.find_by_id(@id)
    @client                 = Company.find_by_id(@offer.client_id)
    @ownership              = Company.where(:category => "ownership", :user_id => current_user.admin_id).last
    @offer_products         = OfferProduct.joins("JOIN offers ON offers.id = offer_products.offer_id JOIN products ON offer_products.product_id = products.id").where("offers.id" => @id).select("offer_products.unit AS unit, offer_products.packages_quantity AS packages_quantity, offer_products.packages_size AS packages_size, offer_products.package_price AS package_price, offer_products.id AS product_id, offer_products.expiration_date AS expiration_date, products.name AS name, products.product_code AS product_code, products.tax_group_id AS tax_group_id")
    @pc                     = PaymentCondition.find_by_id(@offer.payment_condition)

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
    PdfFileUpload.upload_pdf_file(file, @offer.id, @admin_id, "offer", "document")

    #Remove the tmp file
    FileUtils.rm(file_path)

    render :layout => "pdf_document"
  end

  def send_pdf_by_email

    @email      = ""
    @subject    = ""
    @body       = ""
    @from       = ""
    @file_name  = ""
    @file       = ""

    #Defined the vars

    UserMailer.delay.pdf_email(@email, @subject, @body, @from, @file_name, @file)
  end

  def create
    @offer                  = Offer.create(offer_params)
    @offer_products         = params[:offer][:offerproducts][:offerproduct]
    @commit                 = params[:commit]

    @offer_products.each do |op|
      unless op[1]["packages_quantity"] == ""
        OfferProduct.create(:product_id => op[1]["product_id"], :packages_quantity => op[1]["packages_quantity"], :packages_size => op[1]["packages_size"], :package_price => op[1]["package_price"],  :unit => op[1]["unit"], :expiration_date => op[1]["expiration_date"], :offer_id => @offer.id, :user_id => current_user.id)
      end
    end

    if @commit.include? "PDF"
      redirect_to "/offers/?pdf_id=#{@offer.id}"
    else
      redirect_to action: "index"
    end
  end

  def update
    @id                     = params[:id]
    @offer                  = Offer.find_by_id(@id)
    @commit                 = params[:commit]

    @offer.update(offer_params)

    if @commit.include? "PDF"
      redirect_to "/offers/?pdf_id=#{@offer.id}"
    else
      redirect_to action: "index"
    end
  end

  def destroy
    @id       = params[:id]
    @offer    = Offer.find_by_id(@id)
    @offer.destroy

    #Destroy offer products as well
    @offer_products = OfferProduct.where(:offer_id => @id)
    @offer_products.each do |product|
      product.destroy
    end

    redirect_to action: "index"
  end

  def offer_params
     params.require(:offer).permit(:client_id, :user_id, :sum, :offerproducts, :note, :reference_id, :issue_date, :payment_condition, :delivery_terms)
  end

end
