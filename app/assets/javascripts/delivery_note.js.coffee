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
        packageQuantify   = $(this).find('.packages-quantity input').val()
        packagePrice      = $(this).find('.package-price input').val()

        if packageQuantify > 0 && packagePrice > 0
          productPrice    = parseFloat(packageQuantify) * parseFloat(packagePrice)
          totalPrice      = totalPrice + productPrice

          # Update total price
          $("#delivery_note_sum").val totalPrice.toFixed(2)
          $("#delivery_note_sum-holder").html totalPrice.toFixed(2)

      return

  #Show today's date when creating new delivery date
  checkTodaysDate : () ->
    if $('form').attr('action') == "/delivery_notes"
      $(".datepicker" ).datepicker("setDate", new Date());


  #When client changed the list of delivery addresses needs to be updated
  clientChange : () ->
    $('body').delegate '#delivery_note_client_id', 'selectmenuchange', ->
      $('#delivery-addresses-cover').html()
      id =  $('#delivery_note_client_id').val()
      actions.ajax 'get', "/delivery_notes/delivery_addresses/#{id}", $('#delivery-addresses-cover')
      $("select:visible").selectmenu()

  init : () ->
    deliveryNote.calculateDeliveryNotePrice()
    deliveryNote.checkTodaysDate()
    deliveryNote.clientChange()


jQuery ($) ->
  deliveryNote.init()