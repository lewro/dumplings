###
  File          Offer Product JS
  Application   Littl factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@offerProduct =

  #Remove Client Order Product via AJAX
  removeOfferProduct: () ->
    $('body').delegate '.remove-offer-product', 'click', ->
      
      message = $(this).attr("remove-message")      
      result  = confirm(message)
      
      if result == true
        
        id = $(this).parents('.product').data("product-id")
      
        #Recalculate price
        price         = parseInt $(this).parents('.product').find('.package-price').find('.input-holder').html()
        quantity      = parseInt $(this).parents('.product').find('.packages-quantity').find('.input-holder').html()
        productPrice  = price * quantity    
        oldTotal      = parseInt $('#offer_sum').val()
        newTotal      = oldTotal - productPrice   

        $('#offer_sum').val(newTotal)
        $('#offer_sum').prev('.input-holder.big').html(newTotal)
        
        actions.ajax 'delete', "/offer_products/#{id}", ""      
        $(this).parents('.product').remove()




  #Add New Client Order Product on NEW View
  addNewOfferProduct : () ->  
    $('body').delegate '#add-new-offer-product', 'click', ->

      newProduct = $('#offer-products .product:last').clone()
      $(newProduct).appendTo('#offer-products')

      #Select
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

      #Remove haDatepicker class to fix the issue with calendar not appearing
      $(".datepicker").removeClass("hasDatepicker")

      $(".product:last").find('select, input').show()

      #Reinitiate the UI
      core.init()       
      
      
    #Add New Client Order Product on Edit View
    $('body').delegate '#add-new-offer-product-edit', 'click', ->
      $(this).hide()
      hiddenForm = $(".hidden-form").show()
      $("#hiden-form-cover").append(hiddenForm)
      core.init()             

      
  init : () ->            
    offerProduct.removeOfferProduct()
    offerProduct.addNewOfferProduct()    

jQuery ($) ->
  offerProduct.init()
