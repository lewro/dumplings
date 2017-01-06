class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    #users set in application controller
  end

  def edit  
    @id   = params[:id]
    @user = User.find_by_id(@id)
  end
  
  def new
    @user  = User.new  
  end  
  
  def create
    #TODO: Only admin can create users

    @user       = User.create(user_params)    
    @email      = params[:user][:email]
    @password   = params[:user][:password]
    @emailExist = User.where(:email => @email).size
    @error      = ""
    
    if @emailExist > 0
      @error = t 'errors.email_exists'
    end
    
    if @password.length < 6
      @error = @error + " & #{t 'errors.password_length'}"
    end
    
    #Admin ID
    @user.admin_id = current_user.id

    if @user.save
        redirect_to action: "index"               
    else
      flash[:notice] =  @error
    end
  end  

  def update
    @id       = params[:id]    
    @user     = User.find_by_id(@id)

    @user.update(user_params)
    
    redirect_to action: "index"        
  end
  
  def destroy
    @id         = params[:id]    
    @user       = User.find_by_id(@id)
    @companies  = Company.where(:sales_id => @id)
    
    if @companies.size > 0
      flash[:notice] = t "errors.companies_exist"      
      redirect_to action: "edit"         
    else
      @user.destroy
      redirect_to action: "index"      
    end
  end  

  def settings
    @id                     = current_user.id    
    @user                   = User.find_by_id(@id)
        
    @logo_new               = FileUpload.new
    @signature_new          = FileUpload.new

    @logo                   = FileUpload.where(:file_type => "company-logo", :model => "user" , :model_id => current_user.admin_id).last    
    @signature              = FileUpload.where(:file_type => "signature", :model => "user" , :model_id => current_user.admin_id).last    
    @path_logo              = "/assets/uploads/" + @logo.user_id.to_s + "/" + @logo.id.to_s + "/medium/" + @logo.upload_file_name
    @path_signature         = "/assets/uploads/" + @signature.user_id.to_s + "/" + @signature.id.to_s + "/medium/" + @signature.upload_file_name


  end

  def user_params
     params.require(:user).permit(:first_name, :last_name, :email, :category, :note, :password)
  end

end
