class FileUploadsController < ApplicationController
  before_action :authenticate_user!

  def create
    @file_upload  	= FileUpload.new(file_params)
    @file_type 			= params[:file_upload][:file_type]
    @model_id 			= params[:file_upload][:model_id] 
		@file_name			= @file_upload.upload_file_name

    #Files stored under Account / Admin ID
    @user_id        = User.find(@file_upload.user_id).admin_id
    
    if @file_upload.save
    	@path = @file_upload_images_path + @user_id.to_s + "/" + @file_upload.id.to_s + "/medium/" + @file_name
      render :partial => "file"
    else
      flash[:notice] = t "errors.update"
    end  	
  end

  def download_pdf 
    @file_upload  = FileUpload.find(params[:id])
    @path         = @file_download_pdf_path + @file_upload.id.to_s + "/" + @file_upload.upload_file_name
    
    send_file(@path, filename: 'PDF', type: 'application/pdf', disposition: :inline)
  end

  def remove_pdf 
    @file_upload  = FileUpload.find(params[:id])  
    @folder       = @file_download_pdf_path + @file_upload.id.to_s + "/" 
    @path         = @folder + @file_upload.upload_file_name
    @model        = @file_upload.model
    @model_id     = @file_upload.model_id

    @file_upload.destroy

    #FileUtils.rm(@path)
    FileUtils.rm_rf(@folder)

    redirect_to "/#{@model}s/#{@model_id}/edit"
  end

  def file_params
    params.require(:file_upload).
      permit(:upload_file_name, :upload_content_type, :upload, :upload_file_size, :model_id, :model, :file_type, :user_id, {:upload => []})
  end
end