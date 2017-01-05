class FileUpload < ActiveRecord::Base

  user_id = User.find(self.user_id).admin_id

  if Rails.env.production?
    path = "/var/www/sites/getquantify/current/public/system/:attachment/" + user_id + "/:id/:style/:basename.:extension"
  else
    path = ":rails_root/app/assets/images/:attachment/" + user_id + "/:id/:style/:basename.:extension"
  end

  has_attached_file :upload, :styles => {:thumb => "50x50#", :medium => "300x300>" },
                    path: path,
                    url:  "/assets/images/uploads/:attachment/:id/:style/:basename.:extension"

	validates_attachment_presence :upload
  validates_attachment_size :upload, :less_than => 10.megabytes
  validates_attachment_content_type :upload,
                                    :content_type => ["application/vnd.ms-excel", "application/postscript" ,"application/pdf", "application/msword", "application/msexcel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/binary", "application/zip", "application/jar", "image/jpg", "image/jpeg", "image/pjpeg", "image/png", "image/xpng" ,"image/gif", "image/tiff", "image/vnd.adobe.photoshop", "image/vnd.adobe.illustrator" ,"text/rtf", "application/rtf" , "text/txt", "application/mp3", "application/x-mp3", "audio/mpeg", "audio/mp3", "text/html", "application/html", "application/xml", "application/xhtml+xml", "text/csv", "application/json", "text/plain", "image/x-ms-bmp", "image/bmp", "image/x-bmp", "image/x-bitmap", "image/x-xbitmap", "image/x-win-bitmap", "image/x-windows-bmp", "image/ms-bmp", "application/bmp", "application/x-bmp", "application/x-win-bitmap", "application/vnd.openxmlformats-officedocument.presentationml.presentation", "image/vnd.dwg", "application/mp4", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "application/octet-stream", "application/octet-steam", "application/vnd.oasis.opendocument.spreadsheet"]


end