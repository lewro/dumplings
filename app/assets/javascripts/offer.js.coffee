###
  File          Offer JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@offer =

  # Calculate Total Price of Order
  calculateOfferPrice : () ->
  
    $('body').delegate '#offer input', 'keyup', ->

      totalPrice = 0
    
      $('#offer .product').each ->
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
          $("#offer_sum").val totalPrice
      return

  #Show today's date when creating new offer 
  checkTodaysDate : () ->
    if $('form').attr('action') == "/offers"
      $(".datepicker" ).datepicker("setDate", new Date());

  init : () ->         
    offer.calculateOfferPrice()
    offer.checkTodaysDate()


jQuery ($) ->
  offer.init()