class DeliveryNotesController < ApplicationController
  before_action :authenticate_user!


  def new
    @delivery_note                  = DeliveryNote.new
    @delivery_note_product          = DeliveryNoteProduct.new

    #When note created from existing order
    if params[:id]
      @order_id                     = params[:id]
      @order                        = ClientOrder.find_by_id(@order_id)
      @order_products               = ClientOrderProduct.where(:order_id => @order_id)
      @sum                          = 0

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
    end
    
    @invoice        = Invoice.where(:order_id => @order_id, :proforma => false).first
    @proforma       = Invoice.where(:order_id => @order_id, :proforma => true).first
    
  end

  def index
    @delivery_notes = DeliveryNote.joins("JOIN users ON users.id = delivery_notes.user_id").joins("JOIN companies ON companies.id = delivery_notes.client_id").where("users.admin_id = #{current_user.admin_id}").select("delivery_notes.reference_id AS reference_id, delivery_notes.order_id AS order_id, delivery_notes.sum AS sum, delivery_notes.note AS note, delivery_notes.payment_condition AS payment_condition, delivery_notes.id AS id, companies.name AS company_name")
  end

  def edit
    @id                       = params[:id]
    @delivery_note            = DeliveryNote.find_by_id(@id)
    @client                   = Company.find_by_id(@delivery_note.client_id) 
    @delivery_note_products   = DeliveryNoteProduct.joins("JOIN products ON delivery_note_products.product_id = products.id").where(:delivery_note_id => @id).select("delivery_note_products.packages_quantity AS packages_quantity, delivery_note_products.packages_size AS packages_size, delivery_note_products.unit AS unit, delivery_note_products.package_price AS package_price, delivery_note_products.id AS product_id, products.name AS name")
    @delivery_note_product    = DeliveryNoteProduct.new    
    @order_id                 = @delivery_note.order_id   
    @invoice                  = Invoice.where(:order_id => @delivery_note.order_id, :proforma => false).first
    @proforma                 = Invoice.where(:order_id => @delivery_note.order_id, :proforma => true).first
  end

  def create
    @delivery_note            = DeliveryNote.create(delivery_note_params)
    @delivery_note_products   = params[:delivery_note][:deliverynoteproducts][:deliverynoteproduct]

    @delivery_note_products.each do |dnp|
      unless dnp[1]["packages_quantity"] == ""
        DeliveryNoteProduct.create(:product_id => dnp[1]["product_id"], :packages_quantity => dnp[1]["packages_quantity"], :packages_size => dnp[1]["packages_size"], :package_price => dnp[1]["package_price"],  :unit => dnp[1]["unit"],  :delivery_note_id => @delivery_note.id, :user_id => current_user.id)
      end
    end

    redirect_to action: "index"    
  end

  def update
    @id = params[:id]    
    @delivery_note = DeliveryNote.find_by_id(@id)
    @delivery_note.update(delivery_note_params)
    
    redirect_to action: "index"   
  end



  def delivery_note_params
    params.require(:delivery_note).permit(:client_id, :user_id, :order_id, :reference_id, :sum, :note, :payment_condition, :issue_date, :deliverynoteproducts)
  end
end