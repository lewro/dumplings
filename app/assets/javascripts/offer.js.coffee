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
          productPrice    = parseFloat(packageQuantify) * parseFloat(packagePrice)
          totalPrice      = totalPrice + productPrice

          # Update total price.toFixed(2)
          $("#offer_sum").val totalPrice.toFixed(2)
      return

  #Show today's date when creating new offer
  checkTodaysDate : () ->
    if $('#new_offer').length > 0
      $(".datepicker" ).datepicker("setDate", new Date());

  init : () ->
    offer.calculateOfferPrice()
    offer.checkTodaysDate()


jQuery ($) ->
  offer.init()
