###
  File          Retail JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@retail =

  # Calculate Total Price of Order
  calculateOfferPrice : () ->
  
    $('body').delegate '#retail input', 'keyup', ->

      totalPrice = 0
    
      $('#retail .product').each ->
        if $(this).find('.packages-quantity input').length > 0
          packageQuantify   = $(this).find('.packages-quantity input').val()
          packagePrice      = $(this).find('.package-price input').val()
        if $(this).find('.packages-quantity .input-holder').length > 0
          packageQuantify   = $(this).find('.packages-quantity .input-holder').html()
          packagePrice      = $(this).find('.package-price .input-holder').html()

        if packageQuantify > 0 && packagePrice > 0
          productPrice    = parseInt(packageQuantify) * parseInt(packagePrice)
          totalPrice      = totalPrice + productPrice
                                                                                 
          # Update total price
          $("#retail_sum").val totalPrice
      return

  # Show today's date when creating new offer
  checkTodaysDate : () ->
    if $('form').attr('action') == "/retails"
      $(".datepicker" ).datepicker("setDate", new Date());

  init : () ->         
    retail.calculateOfferPrice()
    retail.checkTodaysDate()

jQuery ($) ->
  retail.init()