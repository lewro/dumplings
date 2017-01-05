###
  File          Client Order Product JS
  Application   Littl factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@clientOrderProduct =

  #Remove Client Order Product via AJAX
  removeClientOrderProduct: () ->
    $('body').delegate '.remove-client-order-product', 'click', ->
      
      message = $(this).attr("remove-message")      
      result  = confirm(message)
      
      if result == true
        
        id = $(this).parents('.product').data("product-id")
      
        #Recalculate price
        price         = parseInt $(this).parents('.product').find('.package-price').find('.input-holder').html()
        quantity      = parseInt $(this).parents('.product').find('.packages-quantity').find('.input-holder').html()
        productPrice  = price * quantity    
        oldTotal      = parseInt $('#client_order_sum').val()
        newTotal      = oldTotal - productPrice   

        $('#client_order_sum').val(newTotal)
        
        actions.ajax 'delete', "/client_order_products/#{id}", ""      
        $(this).parents('.product').remove()


  #Add New Client Order Product on NEW View
  addNewClientOrderProduct : () ->  
    $('body').delegate '#add-new-client-order-product', 'click', ->

      newProduct = $('#client-order-products .product:last').clone()
      $(newProduct).appendTo('#client-order-products')

      #Selects
      $(".product:last").find('select').each ->      
        nameAttr    = $(this).attr('name')
        digit       = parseInt(nameAttr.match(/\d+/))
        newDigit    = digit + 1

        $(this).attr 'name', (i, old) ->
          old.replace digit, newDigit
        $(this).attr 'id', (i, old) ->
          old.replace digit, newDigit

      #Input
      $(".product:last").find('input').each ->      
        nameAttr      = $(this).attr('name')
        digit         = parseInt(nameAttr.match(/\d+/))
        newDigit      = digit + 1

        $(this).attr 'name', (i, old) ->
          old.replace digit, newDigit
        $(this).attr 'id', (i, old) ->
          old.replace digit, newDigit

      #Remove the span elements created by Jqeury UI
      $(".product:last").find('span').each ->
        unless $(this).hasClass("ui-icon")
          $(this).remove()

      $(".product:last").find('select, input').show()

      #Remove haDatepicker class to fix the issue with calendar not appearing
      $(".datepicker").removeClass("hasDatepicker")

      #Reinitiate the UI
      core.init()       
      
      
    #Add New Client Order Product on Edit View
    $('body').delegate '#add-new-client-order-product-edit', 'click', ->
      $(this).hide()
      hiddenForm = $(".hidden-form").show()
      $("#hiden-form-cover").append(hiddenForm)
      core.init()             



      
  init : () ->            
    clientOrderProduct.removeClientOrderProduct()
    clientOrderProduct.addNewClientOrderProduct()    

jQuery ($) ->
  clientOrderProduct.init()
