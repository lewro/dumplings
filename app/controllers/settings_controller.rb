class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :access_controll

  def edit_settings
    @setting = Setting.where(:user_id => current_user.admin_id).last

    if @setting.nil?
      @setting = Setting.new
    end

    #File Uploads
    @id                     = current_user.id
    @user                   = User.find_by_id(@id)
    @admin_id               = current_user.admin_id
    @logo_new               = FileUpload.new
    @signature_new          = FileUpload.new

    @logo                   = FileUpload.where(:file_type => "company-logo", :model => "user" , :model_id => current_user.admin_id).last
    @signature              = FileUpload.where(:file_type => "signature", :model => "user" , :model_id => current_user.admin_id).last

    if @logo
      @path_logo = @file_upload_images_path + @admin_id.to_s + "/" + @logo.id.to_s + "/medium/" + @logo.upload_file_name
    end

    if @signature
      @path_signature = @file_upload_images_path + @admin_id.to_s + "/" + @signature.id.to_s + "/medium/" + @signature.upload_file_name
    end
  end

  def update
    @id       = params[:id]
    @setting  = Setting.find_by_id(@id)

    @setting.update(settings_params)

    redirect_to action: "edit_settings"
  end

  def create
    @setting = Setting.create(settings_params)
    redirect_to action: "edit_settings"
  end


  def settings_params
     params.require(:setting).permit(:user_id, :currency, :use_tax, :id_format, :expiration_alert)
  end

end
