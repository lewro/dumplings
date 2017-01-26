class FileUploadsController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:file_upload][:file_type] == "attachment"
      @file_upload = AttachmentFileUpload.new(file_params)
    else
      @file_upload = FileUpload.new(file_params)
    end

    @file_type      = params[:file_upload][:file_type]
    @model_id       = params[:file_upload][:model_id]
    @file_name      = @file_upload.upload_file_name

    #Files stored under Account / Admin ID
    @user_id        = User.find(@file_upload.user_id).admin_id

    if @file_upload.save
      if @file_type == "attachment"
        render :partial => "file", :locals => {:af => @file_upload}
      else
        @path = @file_upload_images_path + @user_id.to_s + "/" + @file_upload.id.to_s + "/medium/" + @file_name
        render :partial => "image"
      end
    else
      flash[:notice] = t "errors.update"
    end
  end

  def download_pdf
    @file_upload  = FileUpload.find(params[:id])
    @path         = @file_download_pdf_path + @file_upload.id.to_s + "/" + @file_upload.upload_file_name

    send_file(@path, filename: 'PDF', type: 'application/pdf', disposition: :inline)
  end

  def download_af
    @file_upload  = FileUpload.find(params[:id])

    if @file_upload.upload_content_type.include? "image"
      @path = @file_download_attachment_img_path + @file_upload.id.to_s + "/" + @file_upload.upload_file_name
      render :partial => "image"
    elsif @file_upload.upload_content_type.include? "pdf"
      @path = @file_download_attachment_path + @file_upload.id.to_s + "/" + @file_upload.upload_file_name
      send_file(@path, filename: 'PDF', type: 'application/pdf', disposition: :inline)
    else
      @path = @file_download_attachment_path + @file_upload.id.to_s + "/" + @file_upload.upload_file_name
      send_file(@path)
    end
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

  def remove_af
    @file_upload  = FileUpload.find(params[:id])
    @folder       = @file_download_pdf_path + @file_upload.id.to_s + "/"
    @path         = @folder + @file_upload.upload_file_name
    @model        = @file_upload.model
    @model_id     = @file_upload.model_id

    @file_upload.destroy

    #FileUtils.rm(@path)
    FileUtils.rm_rf(@folder)

    render :text => "#{t'actions.saved'}"
  end


  def file_params
    params.require(:file_upload).
      permit(:upload_file_name, :upload_content_type, :upload, :upload_file_size, :model_id, :model, :file_type, :user_id, {:upload => []})
  end
end
