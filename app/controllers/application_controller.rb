  class ApplicationController < ActionController::Base
  protect_from_forgery


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


  def set_file_upload_path
    if current_user
      @file_upload_images_path  = "/assets/img/"
      @file_upload_pdf_path     = "/assets/pdf/#{current_user.admin_id}/"
      @file_download_pdf_path   = "#{Rails.root}/app/assets/uploads/pdf/" + current_user.admin_id.to_s + "/"
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

  def set_tax
    if current_user
      @settings   = Setting.where(:user_id => current_user.admin_id).first
      @tax        = @settings.tax
      @use_tax    = @settings.use_tax      
    end
  end


  def set_reps
    if current_user
  	 @reps = User.where(:category => 1, :admin_id => "#{current_user.admin_id}")
  	 return @reps
    end
  end

  def set_clients
    if current_user    
	   @clients = Company.joins("JOIN users ON users.id = companies.user_id").where(:status => 4, :category => "client").where("users.admin_id = #{current_user.admin_id }")
    end
  end

  def set_suppliers
    if current_user    
      @suppliers = Company.joins("JOIN users ON users.id = companies.user_id").where(:status => 4, :category => "supplier").where("users.admin_id = #{current_user.admin_id }") 
    end
  end

  def set_products
    if current_user
      @products = Product.joins("JOIN users ON users.id = products.user_id").where("users.admin_id = #{current_user.admin_id }")
    end
  end

  def set_payment_conditions
    if current_user
      @payment_conditions = PaymentCondition.joins("JOIN users ON users.id = payment_conditions.user_id").where("users.admin_id = #{current_user.admin_id }")
    end
  end

  def set_supplies
    if current_user 
      @supplies =  Supply.joins("JOIN users ON users.id = supplies.user_id").where("users.admin_id = #{current_user.admin_id }")
    end
  end

  def set_users
    if current_user
      @users = User.where("users.admin_id =#{current_user.admin_id }") 
    end
  end
end
