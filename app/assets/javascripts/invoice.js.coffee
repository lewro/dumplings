###
  File          Invoice JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@invoice =

  # Calculate Total Price of Invoice
  calculateInvoicePrice : () ->
  
    $('body').delegate '#invoice input', 'keyup', ->

      totalPrice = 0
    
      $('#invoice .product').each ->
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
          $("#invoice_sum").val totalPrice

          console.log "hop"
      return

  markInvoiceAsPaid : () ->
    $('body').delegate '.mark-invoice-as-paid', 'click', ->      
      dataElement = $(this).parents(".data")
      invoiceID = $(dataElement).attr("data-invoice-id")
      justNow   = $(dataElement).attr("data-just-now")

      actions.ajax 'get', "/invoices/mark_invoice_as_paid/#{invoiceID}", ""  
            
      $(dataElement).find('.invoice_paid_date').html(justNow)      
      $(dataElement).find('.invoice_balance').html(0).removeClass('pasive').addClass('active')
      false

  init : () ->     
    invoice.calculateInvoicePrice()       
    invoice.markInvoiceAsPaid()

jQuery ($) ->
  invoice.init()