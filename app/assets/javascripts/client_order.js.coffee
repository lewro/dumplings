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

  checkStockAvailability : () ->
    $('body').delegate '.packages-size input, .packages-quantity input', 'change', ->

      productRow          = $(this).parents(".product")
      packagesQuantity    = $(productRow).find(".packages-quantity input").val()
      packagesSize        = $(productRow).find(".packages-size input").val()
      unit                = $(productRow).find('.unit-select select').val()
      product             = $(productRow).find('.product-select select').val()

      if packagesQuantity > 0 && packagesSize > 0

        vars = "?product_id=" + product + "&unit=" +  unit + "&packages_quantity=" + packagesQuantity + "&packages_size=" + packagesSize

        actions.ajax 'get', "/stocks/check_product_availability/"+vars, $(".alert")


  attachFile : () ->
    if $('#client-order').length > 0
      param =  core.getUrlVar "attach_file"
      if param == "true"
        $('.hidden-upload-form').show()
        core.clearAllParamsFromUrl()

  init : () ->
    clientOrder.attachFile()
    clientOrder.markOrderAsInProgress()
    clientOrder.markOrderAsDistributed()
    clientOrder.calculateClientOrderPrice()
    clientOrder.checkStockAvailability()


jQuery ($) ->
  clientOrder.init()
