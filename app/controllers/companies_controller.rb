class CompaniesController < ApplicationController
  before_action :authenticate_user!

  def new
    @category         = params[:category]            
    @client           = Company.new
  end
  
  def create
    @category         = params[:company][:category]
    @company          = Company.create(company_params)
   
    if @category == 'client'
      @category = 'clients'
    else 
      @category = 'suppliers'
    end

    redirect_to action: "index", :category => @category   
  end
  
  def index
    @category = params[:category] 

    if @category == "clients"
      @companies = Company.joins('LEFT JOIN client_orders ON client_orders.client_id = companies.id JOIN users ON users.id = companies.sales_id').where(:category => "client").select("users.first_name AS first_name, users.last_name AS last_name, companies.id AS id, companies.name AS name, companies.street AS street, companies.street_number AS street_number, companies.city AS city, companies.zip_code AS zip_code,  companies.status AS status, companies.contact_person AS contact_person, count(client_orders.id) AS orders").group("id")           
    else
      @companies = Company.joins('LEFT JOIN supplier_orders ON supplier_orders.supplier_id = companies.id').where(:category => "supplier").select("companies.id AS id, companies.name AS name, companies.street AS street, companies.street_number AS street_number, companies.city AS city, companies.zip_code AS zip_code,  companies.status AS status, companies.contact_person AS contact_person, count(supplier_orders.id) AS orders").group("id")      
      @category = "suppliers"
    end    

  end

  def edit
    @category           = params[:category]    
    @id                 = params[:id]
    @client             = Company.joins('LEFT JOIN client_orders ON client_orders.client_id = companies.id LEFT JOIN invoices ON invoices.client_id = companies.id').where("companies.id" => @id).select("companies.id AS id, companies.sales_id AS sales_id, companies.name AS name, companies.street AS street, companies.street_number AS street_number, companies.city AS city, companies.zip_code AS zip_code,  companies.status AS status, companies.registration_number AS registration_number, companies.vat_number AS vat_number, companies.note AS note, companies.contact_person AS contact_person, count(client_orders.id) AS orders, sum(invoices.sum) AS sales").group("id").first    
    @orders             = ClientOrder.where(:client_id => @id).size
    @delivery_notes     = DeliveryNote.where(:client_id => @id).size
    @invoices           = Invoice.where(:client_id => @id).size
    @offers             = Offer.where(:client_id => @id).size
  end

  def update
    @id = params[:id]    
    @client = Company.find_by_id(@id)
    @client.update(company_params)
    
    redirect_to action: "index"   
  end

  def destroy
    @id = params[:id]    
    @client = Company.find_by_id(@id)
    @client.destroy
    
    redirect_to action: "index"     
  end

  def company_params
     params.require(:company).permit(:name, :status, :user_id, :street, :street_number, :city, :zip_code, :note, :registration_number, :vat_number, :category, :sales_id, :contact_person)
  end
  
end
