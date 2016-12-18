###
  File          Delivery Note Product JS
  Application   Littl factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@deliveryNoteProduct =

  #Remove Delivery Note Product via AJAX
  removeDeliveryNoteProduct: () ->
    $('body').delegate '.remove-delivery-note-product', 'click', ->
      
      message = $(this).attr("remove-message")      
      result  = confirm(message)
      
      if result == true
        
        id = $(this).parents('.product').data("product-id")
      
        #Recalculate price
        price         = parseInt $(this).parents('.product').find('.package-price').find('.input-holder').html()
        quantity      = parseInt $(this).parents('.product').find('.packages-quantity').find('.input-holder').html()
        productPrice  = price * quantity    
        oldTotal      = parseInt $('#delivery_note_sum').val()
        newTotal      = oldTotal - productPrice   

        $('#delivery_note_sum').val(newTotal)
        
        actions.ajax 'delete', "/delivery_note_products/#{id}", ""      
        $(this).parents('.product').remove()


  #Add New Delivery Note Product on NEW View
  addNewDeliveryNoteProduct : () ->  
    $('body').delegate '#add-new-delivery-note-product', 'click', ->

      newProduct = $('#delivery-note-products .product:last').clone()
      $(newProduct).appendTo('#delivery-note-products')

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

      #Remov the span elements created by Jqeury UI
      $(".product:last").find('span').each ->
        $(this).remove()
      $(".product:last").find('select, input').show()

      #Reinitiate the UI
      core.init()       
      
      
    #Add New Delivery Note Product on Edit View
    $('body').delegate '#add-new-delivery-note-product-edit', 'click', ->
      $(this).hide()
      hiddenForm = $(".hidden-form").show()
      $("#hiden-form-cover").append(hiddenForm)
      core.init()             



      
  init : () ->            
    deliveryNoteProduct.removeDeliveryNoteProduct()
    deliveryNoteProduct.addNewDeliveryNoteProduct()    

jQuery ($) ->
  deliveryNoteProduct.init()