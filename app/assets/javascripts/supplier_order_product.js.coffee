###
  File          Supplier Order Product JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@supplierOrderProduct =

  #Remove Client Order Product via AJAX
  removeSupplierOrderProduct: () ->
    $('body').delegate '.remove-supplier-order-product', 'click', ->

      message = $(this).attr("remove-message")
      result  = confirm(message)

      if result == true

        id = $(this).parents('.product').data("product-id")

        #Recalculate price
        price         = parseInt $(this).parents('.product').find('.package-price').find('.input-holder').html()
        quantity      = parseFloat $(this).parents('.product').find('.packages-quantity').find('.input-holder').html()
        productPrice  = price * quantity
        oldTotal      = parseFloat $('#supplier_order_sum').val()
        newTotal      = oldTotal - productPrice

        $('#supplier_order_sum').val(newTotal.toFixed(2))
        $('#supplier_order_sum').prev('.input-holder.big').html(newTotal.toFixed(2))

        actions.ajax 'delete', "/supplier_order_products/#{id}", ""
        $(this).parents('.product').remove()

  #Add New Client Order Product on NEW View
  addNewSupplierOrderProduct : () ->
    $('body').delegate '#add-new-supplier-order-product', 'click', ->

      newProduct = $('#supplier-order-products .product:last').clone()
      $(newProduct).appendTo('#supplier-order-products')

      $(".product:last").find('select').each ->

        nameAttr    = $(this).attr('name')
        digit       = parseFloat(nameAttr.match(/\d+/))
        newDigit    = digit + 1

        $(this).attr 'name', (i, old) ->
          old.replace digit, newDigit
        $(this).attr 'id', (i, old) ->
          old.replace digit, newDigit

      $(".product:last").find('input').each ->

        nameAttr      = $(this).attr('name')
        digit         = parseFloat(nameAttr.match(/\d+/))
        newDigit      = digit + 1

        $(this).attr 'name', (i, old) ->
          old.replace digit, newDigit
        $(this).attr 'id', (i, old) ->
          old.replace digit, newDigit

      #Remov the span elements created by Jqeury UI
      $(".product:last").find('span').each ->
        unless $(this).hasClass("ui-icon")
          $(this).remove()

      #Remove haDatepicker class to fix the issue with calendar not appearing
      $(".datepicker").removeClass("hasDatepicker")

      $(".product:last").find('select, input').show()

      #Reinitiate the UI
      core.init()


    #Add New Client Order Product on Edit View
    $('body').delegate '#add-new-supplier-order-product-edit', 'click', ->
      $(this).hide()
      hiddenForm = $(".hidden-form").show()
      $("#hiden-form-cover").append(hiddenForm)
      core.init()

  init : () ->
    supplierOrderProduct.removeSupplierOrderProduct()
    supplierOrderProduct.addNewSupplierOrderProduct()

jQuery ($) ->
  supplierOrderProduct.init()
