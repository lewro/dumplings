###
  File          Retail Product JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@retialProduct =

  #Remove Retail Product via AJAX
  removeRetailProduct: () ->
    $('body').delegate '.remove-retail-product', 'click', ->

      message = $(this).attr("remove-message")
      result  = confirm(message)

      if result == true

        id = $(this).parents('.product').data("product-id")

        #Recalculate price
        price         = parseFloat $(this).parents('.product').find('.package-price').find('input').val()
        quantity      = parseFloat $(this).parents('.product').find('.packages-quantity').find('input').val()
        productPrice  = price * quantity


        oldTotal      = parseFloat $('#retail_sum').val()
        newTotal      = oldTotal - productPrice

        $('#retail_sum').val(newTotal.toFixed(2))
        $('#retail_sum').prev('.input-holder.big').html(newTotal.toFixed(2))

        actions.ajax 'delete', "/retail_products/#{id}", ""
        $(this).parents('.product').remove()

  #Add New Client Order Product on NEW View
  addNewRetailProduct : () ->
    $('body').delegate '#add-new-retial-product', 'click', ->

      newProduct = $('#retail-products .product:last').clone()
      $(newProduct).appendTo('#retail-products')

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
    $('body').delegate '#add-new-retail-product-edit', 'click', ->
      $(this).hide()
      hiddenForm = $(".hidden-form").show()
      $("#hiden-form-cover").append(hiddenForm)
      core.init()

  init : () ->
    retialProduct.removeRetailProduct()
    retialProduct.addNewRetailProduct()

jQuery ($) ->
  retialProduct.init()
