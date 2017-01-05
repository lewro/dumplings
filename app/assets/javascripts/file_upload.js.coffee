###
  File          File Upload JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###


@file =

  fileUploadJQ : () ->
  
    $('#file_upload').fileupload
      dataType: 'html'
      success : (data) ->
        $('.file-list').prepend(data)
      add: (e, data) ->
        #Validation
        types = /(\.|\/)(gif|jpe?g|png|json|csv|htm|xhtml|html|xml|css|tif|tiff|doc|pps|wav|avi|mpg|mpeg|wmv|mpeg3|psd|txt|rtf|mp3|mp4|docx|xls|flv|mov|xsl|rss|xslt|zip|x-png|xlsx|ai|eps|bmp|pptx|dwg|dlx|pdf|ods|)$/i

        file = data.files[0]
        if types.test(file.type) || types.test(file.name)
          data.context = $(tmpl("template-upload", file))
          $('#file_upload').append(data.context)
          if file.size > 10000000
            alert "#{file.name} is too big"
          else
            data.submit()
        else
          alert "#{file.name} not supported"

      #Progress bar
      progress: (e, data) ->
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          data.context.find('.bar').css('width', progress + '%')

    $('#file_upload_upload').attr('name', 'file_upload[upload]')

  init : () ->         
    file.fileUploadJQ()

jQuery ($) ->
  file.init()            