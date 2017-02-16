class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_pagination
  before_filter :set_reps
  before_filter :set_clients
  before_filter :set_suppliers
  before_filter :set_products
  before_filter :set_payment_conditions
  before_filter :set_supplies
  before_filter :set_users
  before_filter :set_currency
  before_filter :set_tax
  before_filter :set_file_upload_path
  before_filter :set_images
  before_filter :set_tax_groups
  before_filter :set_id_format

  helper_method :user_has_access
  helper_method :unit

  def unit(value)
    value = value.to_i
    puts case value

    #Pieces
    when 1
      return "#{t'unit.pieces'}"

    #Wieghts
    when 2
      return "#{t'unit.t'}"
    when 3
      return "#{t'unit.kg'}"
    when 4
      return "#{t'unit.g'}"
    when 5
      return "#{t'unit.mg'}"

    #Length
    when 6
      return "#{t'unit.km'}"
    when 7
      return "#{t'unit.m'}"
    when 8
      return "#{t'unit.cm'}"
    when 9
      return "#{t'unit.mm'}"

    #Liquids
    when 10
      return "#{t'unit.kl'}"
    when 11
      return "#{t'unit.hl'}"
    when 12
      return "#{t'unit.dal'}"
    when 13
      return "#{t'unit.l'}"
    when 14
      return "#{t'unit.dl'}"
    when 15
      return "#{t'unit.cl'}"
    when 16
      return "#{t'unit.ml'}"
    end
  end

  def set_pagination
     return @pagination = 20
  end

  def access_controll
    if user_has_access(controller_name)
    else
      redirect_to events_path
    end
  end

  def user_has_access(controller_name)

    #1 - Sales
    #2 - Factory worker
    #3 - Admin - clerk not administrator
    #4 - Delivery
    #5 - Management

    if current_user

      puts case controller_name

      when "events", "clients"
        if [1, 3, 5].include? current_user.category
          return true
        end

      when "companies"
        if [1].include? current_user.category
          if params[:category] == "clients"
            return true
          elsif params[:category] == "suppliers"
            return false
          end
        elsif [3, 5].include? current_user.category
          return true
        end

      when  "dashboards", "your_company", "suppliers", "offers", "offer_products", "client_orders", "delivery_addresses", "client_order_products", "delivery_notes", "delivery_note_products", "file_uploads", "invoices", "invoice_products", "retails", "retail_products", "supplier_orders", "supplier_order_products", "stocks", "settings", "users", "payments", "payment_conditions", "products", "product_supplies", "supplies", "payment_conditions", "tax_groups"
        if [3, 5].include? current_user.category
          return true
        end

      end
    end
  end

  def set_file_upload_path
    if current_user
      @file_upload_images_path              = "/assets/img/"
      @file_upload_pdf_path                 = "/assets/pdf/#{current_user.admin_id}/"
      @file_download_pdf_path               = "#{Rails.root}/app/assets/uploads/pdf/" + current_user.admin_id.to_s + "/"
      @file_download_attachment_path        = "#{Rails.root}/app/assets/uploads/attachment/" + current_user.id.to_s + "/"
      @file_download_attachment_img_path    = "/assets/attachment/" + current_user.id.to_s + "/"
    end
  end

  def set_images
    if current_user
      @logo                   = FileUpload.where(:file_type => "company-logo", :model => "user" , :model_id => current_user.admin_id).last
      @signature              = FileUpload.where(:file_type => "signature", :model => "user" , :model_id => current_user.admin_id).last

     #Account / Admin ID
      @admin_id               = current_user.admin_id

      if @logo
        @path_logo = @file_upload_images_path + @admin_id.to_s + "/" + @logo.id.to_s + "/medium/" + @logo.upload_file_name
      end

      if @signature
        @path_signature = @file_upload_images_path + @admin_id.to_s + "/" + @signature.id.to_s + "/medium/" + @signature.upload_file_name
      end
    end
  end

  def set_currency
    if current_user
      @currency = Setting.where(:user_id => current_user.admin_id).first.currency
      return @currency
    end
  end

  def set_id_format
    if current_user
      @settings     = Setting.where(:user_id => current_user.admin_id).first
      @id_format   = @settings.id_format
    end
  end

  def set_tax
    if current_user
      @settings   = Setting.where(:user_id => current_user.admin_id).first
      @use_tax    = @settings.use_tax
    end
  end

  def set_reps
    if current_user
     @reps = User.where(:category => 1, :admin_id => "#{current_user.admin_id}").order("users.id DESC")
     return @reps
    end
  end

  def set_tax_groups
    if current_user
     @tax_groups = TaxGroup.joins("JOIN users ON users.id = tax_groups.user_id").where("users.admin_id = #{current_user.admin_id }").order("tax_groups.id DESC")
    end
  end

  def set_clients
    if current_user
     @clients = Company.paginate(:page => params[:page], :per_page => @pagination).joins("JOIN users ON users.id = companies.user_id").where(:status => 4, :category => "client").where("users.admin_id = #{current_user.admin_id }").order("companies.id DESC")
    end
  end

  def set_suppliers
    if current_user
      @suppliers = Company.paginate(:page => params[:page], :per_page => @pagination).joins("JOIN users ON users.id = companies.user_id").where(:status => 4, :category => "supplier").where("users.admin_id = #{current_user.admin_id }").order("companies.id DESC")
    end
  end

  def set_products
    if current_user
      @products = Product.paginate(:page => params[:page], :per_page => @pagination).joins("JOIN users ON users.id = products.user_id").where("users.admin_id = #{current_user.admin_id }")
    end
  end

  def set_payment_conditions
    if current_user
      @payment_conditions = PaymentCondition.paginate(:page => params[:page], :per_page => @pagination).joins("JOIN users ON users.id = payment_conditions.user_id").where("users.admin_id = #{current_user.admin_id }").order("payment_conditions.id DESC")
    end
  end

  def set_supplies
    if current_user
      @supplies =  Supply.paginate(:page => params[:page], :per_page => @pagination).joins("JOIN users ON users.id = supplies.user_id").where("users.admin_id = #{current_user.admin_id }").order("supplies.id DESC")
    end
  end

  def set_users
    if current_user
      @users = User.paginate(:page => params[:page], :per_page => @pagination).where("users.admin_id =#{current_user.admin_id }").order("users.id DESC")
    end
  end

  def update_stock(object_name, object, products, time)

    puts case object_name

    #Client Order
    when "client_order", "retail"
      if object.stock_deducted
        #Stock already deducted
      else
        #Deduct stock annd mark delivery not as stock deducted
        remove_from_stock(products, time, object_name, object.id)
        object.update(:stock_deducted => true)
      end
    #Delivery Note
    when "delivery_note"
      #Stock already deducted from current delivery note
      if object.stock_deducted
      #Does Client order exist?
      else
        if object.order_id
          client_order  = ClientOrder.where(:id => object.order_id).first
          if client_order && client_order.stock_deducted
            #Stock already deducted
          else
            remove_from_stock(products, time, object_name, object.id)
            object.update(:stock_deducted => true)
          end
         else
            remove_from_stock(products, time, object_name, object.id)
            object.update(:stock_deducted => true)
        end
      end
    #Invoice
    when "invoice"
      if object.stock_deducted
         #Stock already deducted from Invoice
      else
        if object.order_id
          #Does Client order exist?
          client_order  = ClientOrder.find_by_id(object.order_id)
          delivery_note = DeliveryNote.where(:order_id => client_order.id).first
          #Stock deduceted already from client order or delivery note?
          if (client_order && client_order.stock_deducted) or (delivery_note && delivery_note.stock_deducted)
            #Stock already deducted
          else
            #Is this proforma?
            if object.proforma
              remove_from_stock(products, time, object_name, object.id)
              object.update(:stock_deducted => true)
            else
              #Not proforma. Does proforma exist?
              proforma = Invoice.where(:order_id => object.order_id, :proforma => true).first
              if proforma && proforma.stock_deducted
                #Stock already deducted from PrormaInvoice
              else
                remove_from_stock(products, time, object_name, object.id)
                object.update(:stock_deducted => true)
              end
            end
          end
        else
           #No Client order - which conects delivery note, proformat, invoice together
          remove_from_stock(products, time, object_name, object.id)
          object.delay(:run_at => time).update(:stock_deducted => true)
        end
      end
    end
  end


  def remove_from_stock(products, time, actual_object_name, actual_object_id)

    products.each do |product|

      @product_unit     = Product.find_by_id(product.product_id).unit
      @product_supplies = ProductSupply.where(:product_id => product.product_id)

      @product_supplies.each do |product_supply|

        #Convert the unit to the standrd unit (the smallest)
        @standard_unit  = standardize_unit(product_supply.unit)

        #Multiply the supply element by the product "unit"
        if @product_unit = product.unit

          @product_supply_value = product_supply.packages_size * (product.packages_quantity * product.packages_size)

          #Convert the values to the smallest unit
          @ps_value_in_smallest_unit = convert_unit(product_supply.unit, @product_supply_value)

          #Remove supply units from stock
          @stock_products = StockProduct.where(:supply_id => product_supply.supply_id, :unit => @standard_unit, :gone => false).order(:expiration_date)

          #When supply in the stock
          if @stock_products.size > 0

            @stock_products.each do |stock_product|

              #Is there enought in the current package?
              @sp_size = stock_product.packages_size - @ps_value_in_smallest_unit

              #When the package is used move to the next one and remove the current one
              if @sp_size < 0 or @sp_size == 0
                #Record the action in the stop_product_reduction table
                record_stock_product_reduction(stock_product, actual_object_name, actual_object_id, stock_product.packages_size)

                stock_product.update(:gone => true, :packages_size => 0)

                #Update the total value so the next package in loop can be updated
                @ps_value_in_smallest_unit = 0 - @sp_size
              else
                #When the package is not used, deduct the values
                stock_product.delay(:run_at => time).update(:packages_size => @sp_size)
                #Once the correct product is update stop the loop

                #Record the action in the stop_product_reduction table
                record_stock_product_reduction(stock_product, actual_object_name, actual_object_id, @ps_value_in_smallest_unit)
              end
            end
          else
            #Supply not in stock?
            #TODO: SEND EMAIL ?
          end
        else
          #The units product units do not match
          #TODO: Email?
        end
      end
    end
  end

  def record_stock_product_reduction(stock_product, actual_object_name, actual_object_id, product_supply_value)

    stock_product_redution                     = StockProductReduction.new
    stock_product_redution.stock_product_id    = stock_product.id
    stock_product_redution.packages_size       = product_supply_value
    stock_product_redution.actual_model_name   = actual_object_name
    stock_product_redution.actual_model_id     = actual_object_id
    stock_product_redution.user_id             = current_user.id
    stock_product_redution.save!

  end

  #when deleting objects such are client orders, delivery notes, invoices which were used to reduce stock, we need to add the stock back
  def revert_stock (products, actual_model_name, actual_model_id)

    products.each do |product|
      #Find which stock objects were updated by the current model so we can revert them
      @spr = StockProductReduction.where(:actual_model_name => actual_model_name, :actual_model_id => actual_model_id)

      @spr.each do |spr|
        @stock_product      = StockProduct.find_by_id(spr.stock_product_id)
        @new_package_size   = @stock_product.packages_size + spr.packages_size
        @stock_product.update(:packages_size => @new_package_size, :gone => false)
      end
    end

    #Remove the reductions
    @spr.destroy_all
  end

  def standardize_unit(value)
    value = value.to_i
    puts case value
    #Pieces
    when 1
      return 1
    #Wieghts (returns mg)
    when 2, 3, 4, 5
      return 5
    #Length (returns mm)
    when 6, 7, 8, 9
      return 9
    #Liquids (returns ml)
    when 10, 11, 12, 13, 14, 15, 16
      return 16
    end
  end

  def convert_unit(type, value)

    #Converts to smallest unit
    type = type.to_i
    value = value.to_f

    puts case type

    #Pieces
    when 1
      return 1 * value
    #Weights
    when 2
      return (1000000000 * value).to_f
    when 3
      return (1000000 * value).to_f
    when 4
      return (1000 * value).to_f
    when 5
      return (1 * value).to_f
    #Length
    when 6
      return (1000000 * value).to_f
    when 7
      return (1000 * value).to_f
    when 8
      return (10 * value).to_f
    when 9
      return (1 * value).to_f
    #Liquids
    when 10
      return (1000000 * value).to_f
    when 11
      return (100000 * value).to_f
    when 12
      return (10000 * value).to_f
    when 13
      return (1000 * value).to_f
    when 14
      return (100 * value).to_f
    when 15
      return (10 * value).to_f
    when 16
      return (1 * value).to_f
    end
  end

  def calculate_total_invoice_sum_with_tax
    @invoice_products    = InvoiceProduct.joins("JOIN invoices ON invoice_products.invoice_id = invoices.id").joins("JOIN companies ON invoices.client_id = companies.id").joins("JOIN products ON invoice_products.product_id = products.id").joins("JOIN tax_groups ON tax_groups.id = products.tax_group_id ").where(:invoice_id => @invoice.id).select("tax_groups.tax AS tax, invoice_products.packages_quantity AS packages_quantity, invoice_products.package_price AS package_price")
    @price               = 0

    @invoice_products.each do |product|
      @product_price   = product.packages_quantity * product.package_price
      @price           = @price + ((@product_price / 100) * product.tax) + @product_price
    end
    return @price
  end

  def calculate_total_invoice_sum_without_tax
    @invoice_products    = InvoiceProduct.joins("JOIN invoices ON invoice_products.invoice_id = invoices.id").joins("JOIN companies ON invoices.client_id = companies.id").joins("JOIN products ON invoice_products.product_id = products.id").where(:invoice_id => @invoice.id).select("invoice_products.packages_quantity AS packages_quantity, invoice_products.package_price AS package_price")
    @price               = 0

    @invoice_products.each do |product|
      @product_price   = product.packages_quantity * product.package_price
      @price           = @price + @product_price
    end
    return @price
  end

end











