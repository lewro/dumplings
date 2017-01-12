###
  File          PDF JS
  Application   Littl factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@pdf =

  #Remove PDF via AJAX
  removePDF: () ->
    $('body').delegate '.remove-pdf', 'click', ->
      
      message = $(this).attr("remove-message")      
      result  = confirm(message)
      
      if result == true
        id = $(this).parents('.pdf-file').data("pdf-id")
            
        actions.ajax 'post', "/file_uploads/remove_pdf?id=#{id}", ""      
        $(this).parents('.pdf-file').remove()
    
  init : () ->            
    pdf.removePDF()

jQuery ($) ->
  pdf.init()
