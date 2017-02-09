###
  File          File Upload JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###


@file =

  selectFile : () ->
    $('body').delegate '.select-file', 'click', ->
      $(this).parent('form').find('#file_upload_upload').click()

    $('body').delegate '.attach-file', 'click', ->
      $('#file_upload_upload').click()

  fileUploadJQ : () ->
    $('.file_upload').fileupload
      dataType: 'html'
      success : (data) ->
        parent = $(this).parents('form').parent()
        parent.find('.old-file').remove()
        parent.find('.new-file').prepend(data)
        if parent.find('.new-file').find('img').size() > 1
          parent.find('.new-file').find('img').last().remove()
        $('.upload').remove()

      add: (e, data) ->
        #Validation
        types = /(\.|\/)(gif|jpe?g|png|json|csv|htm|xhtml|html|xml|css|tif|tiff|doc|pps|wav|avi|mpg|mpeg|wmv|mpeg3|psd|txt|rtf|mp3|mp4|docx|xls|flv|mov|xsl|rss|xslt|zip|x-png|xlsx|ai|eps|bmp|pptx|dwg|dlx|pdf|ods|)$/i

        file = data.files[0]
        if types.test(file.type) || types.test(file.name)
          data.context = $(tmpl("template-upload", file))
          $(this).append(data.context)
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

  attachmentJQ : () ->
    $('.attachment_upload').fileupload
      dataType: 'html'
      success : (data) ->
        $('.attachment-files').prepend(data)
        $('.attachment-files').prev('.no-data').remove()
        $('.hidden-upload-form').hide()
      add: (e, data) ->
        #Validation
        types = /(\.|\/)(gif|jpe?g|png|json|csv|htm|xhtml|html|xml|css|tif|tiff|doc|pps|wav|avi|mpg|mpeg|wmv|mpeg3|psd|txt|rtf|mp3|mp4|docx|xls|flv|mov|xsl|rss|xslt|zip|x-png|xlsx|ai|eps|bmp|pptx|dwg|dlx|pdf|ods|)$/i

        file = data.files[0]
        if types.test(file.type) || types.test(file.name)
          data.context = $(tmpl("template-upload", file))
          $(this).append(data.context)
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

  init : () ->
    file.attachmentJQ()
    file.fileUploadJQ()
    file.selectFile()

jQuery ($) ->
  file.init()
