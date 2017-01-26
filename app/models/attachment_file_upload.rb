class AttachmentFileUpload < FileUpload

  if Rails.env.production?
    path = "/var/www/sites/dumplings/current/assets/uploads/attachment/:user_id/:id/:basename.:extension"
  else
    path = ":rails_root/app/assets/uploads/attachment/:user_id/:id/:basename.:extension"
  end

  has_attached_file :upload,
                    path: path,
                    url:  "/assets/uploads/attachment/:user_id/:id/:basename.:extension"

	def self.upload_pdf_file(file, model_id, user_id, model, file_type)
    @file_upload = AttachmentFileUpload.new(:upload => file)
    @file_upload.update(:model_id => model_id, :model => model, :user_id => user_id, :file_type => file_type )
    @file_upload.save!
  end
end