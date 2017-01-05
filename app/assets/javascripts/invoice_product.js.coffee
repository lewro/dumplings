###
  File          Invoice Product JS
  Application   Littl factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@invoiceProduct =

  #Remove Invoice Product via AJAX
  removeInvoiceProduct: () ->
    $('body').delegate '.remove-invoice-product', 'click', ->
      
      message = $(this).attr("remove-message")      
      result  = confirm(message)
      
      if result == true
        
        id = $(this).parents('.product').data("product-id")
      
        #Recalculate price
        price         = parseInt $(this).parents('.product').find('.package-price').find('.input-holder').html()
        quantity      = parseInt $(this).parents('.product').find('.packages-quantity').find('.input-holder').html()
        productPrice  = price * quantity    
        oldTotal      = parseInt $('#invoice_sum').val()
        newTotal      = oldTotal - productPrice   

        $('#invoice_sum').val(newTotal)
        
        actions.ajax 'delete', "/invoice_products/#{id}", ""      
        $(this).parents('.product').remove()


  #Add New Invoice Product on NEW View
  addNewInvoiceProduct : () ->  
    $('body').delegate '#add-new-invoice-product', 'click', ->

      newProduct = $('#invoice-products .product:last').clone()
      $(newProduct).appendTo('#invoice-products')

      #Selects
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
      
      
    #Add New Invoice Product on Edit View
    $('body').delegate '#add-new-invoice-product-edit', 'click', ->
      $(this).hide()      
      hiddenForm = $(".hidden-form").show()
      $("#hiden-form-cover").append(hiddenForm)
      core.init()             
      
  init : () ->            
    invoiceProduct.removeInvoiceProduct()
    invoiceProduct.addNewInvoiceProduct()    

jQuery ($) ->
  invoiceProduct.init()
