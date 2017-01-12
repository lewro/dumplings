###
  File          Stock JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@stock =


  stock : () ->
    
    #NOT USED AT THE MOMENT BUT SHOULD BE USED TO SET REMINDER STOCK LIMITS
    $('.slider').each () -> 

      $(this).slider
        create: (event, ui) ->
          initialValue = $(this).attr("value")          
          $(this).slider 'value', initialValue          
          handle = $(this).find('.ui-slider-handle')          
          handle.text initialValue
          return
          
        slide: (event, ui) ->
          handle = $(this).find('.ui-slider-handle')          
          handle.text ui.value
          return

        stop: (event, ui) ->

          stockId       = $(this).parents('.data').attr("data-stock-id")
          stockValue    = ui.value
                              
          if stockValue == 0

            message = $(this).parents('.data').attr("data-remove-message")
            result  = confirm(message)

            if result == true
              actions.ajax 'delete', "/stocks/#{stockId}", ""
              $(this).parents('.data').remove()
              
          else  
            actions.ajax 'get', "/stocks/update/#{stockId}/?[stock][progress]=#{stockValue}", ""
          
          return

  init : () ->         
    stock.stock()

jQuery ($) ->
  stock.init()        