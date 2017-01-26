###
  File          Attachment JS
  Application   Littl factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@attachment =

  #Remove Attached File via AJAX
  removeAF: () ->
    $('body').delegate '.remove-af', 'click', ->
      
      message = $(this).attr("remove-message")      
      result  = confirm(message)
      
      if result == true
        id = $(this).parents('.af-file').data("af-id")
            
        actions.ajax 'post', "/file_uploads/remove_af?id=#{id}", $('.notice')    
        $(this).parents('.af-file').remove()
    
  init : () ->            
    attachment.removeAF()

jQuery ($) ->
  attachment.init()
