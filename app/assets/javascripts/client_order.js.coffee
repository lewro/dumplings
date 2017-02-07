###
  File          Client Order JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@clientOrder =

  # Calculate Total Price of Order
  calculateClientOrderPrice : () ->

    $('body').delegate '#client-order input', 'keyup', ->

      totalPrice = 0

      $('#client-order .product').each ->
        if $(this).find('.packages-quantity input').length > 0
          packageQuantify   = $(this).find('.packages-quantity input').val()
          packagePrice      = $(this).find('.package-price input').val()
        if $(this).find('.packages-quantity .input-holder').length > 0
          packageQuantify   = $(this).find('.packages-quantity .input-holder').html()
          packagePrice      = $(this).find('.package-price .input-holder').html()

        if packageQuantify > 0 && packagePrice > 0
          productPrice    = parseFloat(packageQuantify) * parseFloat(packagePrice)
          totalPrice      = totalPrice + productPrice

          # Update total price
          $("#client_order_sum").val totalPrice.toFixed(2)
      return

  markOrderAsDistributed : () ->
    $('body').delegate '.mark-client-order-as-distributed', 'click', ->
      dataElement = $(this).parents(".data")
      orderId     = $(dataElement).attr("data-order-id")
      justNow     = $(dataElement).attr("data-just-now")
      closed      = $(dataElement).attr("data-status-closed")

      actions.ajax 'get', "/client_orders/mark_order_as_distributed/#{orderId}", $(".notice")

      $(dataElement).find('.distribution_date').html(justNow)

      $('.mark-client-order-as-in-progress').hide()

      $(dataElement).find('.status').html(closed)

      $(this).hide()

      return false

  markOrderAsInProgress : () ->
    $('body').delegate '.mark-client-order-as-in-progress  ', 'click', ->

      dataElement = $(this).parents(".data")
      orderId     = $(dataElement).attr("data-order-id")
      inProgress  = $(dataElement).attr("data-status-progress")

      actions.ajax 'get', "/client_orders/mark_order_as_in_progress/#{orderId}", $(".notice")

      $(dataElement).find('.status').html(inProgress)

      $(this).hide()

      false

  init : () ->
    clientOrder.markOrderAsInProgress()
    clientOrder.markOrderAsDistributed()
    clientOrder.calculateClientOrderPrice()


jQuery ($) ->
  clientOrder.init()
