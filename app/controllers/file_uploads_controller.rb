class FileUploadsController < ApplicationController
  before_action :authenticate_user!

  def create
    @file_upload  		= FileUpload.new(file_params)  
    @file_type 			= params[:file_upload][:file_type]
    @model_id 			= params[:file_upload][:model_id] 
		@file_name			= @file_upload.upload_file_name
    
    if @file_upload.save
    	@path = "/assets/uploads/" + @file_upload.user_id.to_s + "/" + @file_upload.id.to_s + "/medium/" + @file_name
      render :partial => "file"
    else
      flash[:notice] = t "errors.update"
    end  	
  end

  def file_params
    params.require(:file_upload).
      permit(:upload_file_name, :upload_content_type, :upload, :upload_file_size, :model_id, :model, :file_type, :user_id, {:upload => []})
  end
end