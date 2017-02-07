class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def new
    @category         = params[:category]
    @client           = Company.new

    #Set Default Tax Settings
    @client.use_tax = @use_tax
  end

  def create
    @category         = params[:company][:category]
    @company          = Company.create(company_params)

    @url_category     = translate_categories(@category)

    @company_delivery_adddresses  = params[:company][:companydeliveryaddress][:companydeliveryaddress]

    @company_delivery_adddresses.each do |cda|
      unless cda[1]["street"] == ""
        DeliveryAddress.create(:user_id => @current_user.id, :company_id => @company.id, :street => cda[1]["street"], :street_number => cda[1]["street_number"], :city => cda[1]["city"], :zip_code => cda[1]["zip_code"])
      end
    end

    #Add default address to delivery addresses
    DeliveryAddress.create(:user_id => @current_user.id, :company_id => @company.id, :street => @company.street, :street_number => @company.street_number, :city => @company.city, :zip_code => @company.zip_code)

    redirect_to action: "index", :category => @url_category
  end

  def index
    @category = params[:category]

    if @category == "clients" || @category == "ownership"
      @companies = Company.paginate(:page => params[:page], :per_page => @pagination).joins('LEFT JOIN client_orders ON client_orders.client_id = companies.id JOIN users ON users.id = companies.sales_id').where(:category => "client").select("users.first_name AS first_name, users.last_name AS last_name, companies.id AS id, companies.name AS name, companies.street AS street, companies.street_number AS street_number, companies.city AS city, companies.zip_code AS zip_code,  companies.country AS country, companies.status AS status, companies.contact_person AS contact_person, count(client_orders.id) AS orders").group("companies.id").order("companies.id DESC")
    else
      @companies = Company.paginate(:page => params[:page], :per_page => @pagination).joins('LEFT JOIN supplier_orders ON supplier_orders.supplier_id = companies.id').where(:category => "supplier").select("companies.id AS id, companies.name AS name, companies.street AS street, companies.street_number AS street_number, companies.city AS city, companies.zip_code AS zip_code,  companies.status AS status, companies.contact_person AS contact_person, count(supplier_orders.id) AS orders").group("companies.id").order("companies.id DESC")
      @category = "suppliers"
    end
  end

  def edit
    @category           = params[:category]
    @id                 = params[:id]
    @client             = Company.joins('LEFT JOIN client_orders ON client_orders.client_id = companies.id LEFT JOIN invoices ON invoices.client_id = companies.id').where("companies.id" => @id).select("companies.id AS id, companies.sales_id AS sales_id, companies.name AS name, companies.street AS street, companies.street_number AS street_number, companies.city AS city, companies.zip_code AS zip_code, companies.country AS country,  companies.status AS status, companies.use_tax AS use_tax, companies.registration_number AS registration_number, companies.vat_number AS vat_number, companies.note AS note, companies.contact_person AS contact_person, count(client_orders.id) AS orders, sum(invoices.sum) AS sales").group("id").first
    @orders             = ClientOrder.where(:client_id => @id).size
    @delivery_notes     = DeliveryNote.where(:client_id => @id).size
    @invoices           = Invoice.where(:client_id => @id).size
    @offers             = Offer.where(:client_id => @id).size
    @delivery_addresses = DeliveryAddress.where(:company_id => @id)
    @delivery_address   = DeliveryAddress.new
  end

  def edit_ownership
    @company = Company.where(:category => "ownership", :user_id => current_user.admin_id).last
  end

  def update
    @id       = params[:id]
    @company  = Company.find_by_id(@id)
    @category = @company.category

    @company.update(company_params)


    @url_category     = translate_categories(@category)

    redirect_to action: "index", :category => @url_category
  end

  def destroy
    @id         = params[:id]
    @company    = Company.find_by_id(@id)
    @category   = @company.category
    @addresses  = DeliveryAddress.where(:company_id => @company.id)

    #Destroy delivery addresses
    @addresses.destroy_all

    @company.destroy

    @url_category     = translate_categories(@category)

    redirect_to action: "index", :category => @url_category
  end

  def translate_categories(category)
    if category == 'client'
      category = 'clients'
    else
      category = 'suppliers'
    end
    return category
  end

  def company_params
     params.require(:company).permit(:name, :status, :use_tax, :user_id, :street, :street_number, :city, :zip_code, :country, :note, :registration_number, :vat_number, :category, :sales_id, :contact_person, :bank, :account_number, :swift_code, :iban_code, :legal, :companydeliveryaddress)
  end

end
