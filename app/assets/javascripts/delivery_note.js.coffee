###
  File          Delivery Note JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@deliveryNote =


  # Calculate Total Price of Delivery Note
  calculateDeliveryNotePrice : () ->
  
    $('body').delegate '#delivery-note input', 'keyup', ->    

      totalPrice = 0
    
      $('#delivery-note .product').each ->
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
          $("#delivery_note_sum").val totalPrice
          
      return

  #Show today's date when creating new delivery date 
  checkTodaysDate : () ->
    if $('form').attr('action') == "/delivery_notes"
      $(".datepicker" ).datepicker("setDate", new Date());

  init : () ->
    deliveryNote.calculateDeliveryNotePrice()
    deliveryNote.checkTodaysDate()


jQuery ($) ->
  deliveryNote.init()