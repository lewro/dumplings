require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end

#Allows me to use user_id in path 
Paperclip.interpolates :user_id do |attachment, style|
  "#{attachment.instance.user_id}"
end