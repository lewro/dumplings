###
  File          Supplier Order JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@supplierOrder =

  # Calculate Total Price of Order
  calculateSupplierOrderPrice : () ->
  
    $('body').delegate '#supplier-order input', 'keyup', ->

      totalPrice = 0
    
      $('#supplier-order .product').each ->
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
          $("#supplier_order_sum").val totalPrice
      return

  markOrderAsSent : () ->   
    $('body').delegate '.mark-supplier-order-as-sent', 'click', ->      
      dataElement = $(this).parents(".data")
      orderId     = $(dataElement).attr("data-order-id")
      sent        = $(dataElement).attr("data-status-sent")      

      actions.ajax 'get', "/supplier_orders/mark_order_as_sent/#{orderId}", ""  

      $(dataElement).find('.status').html(sent)      
      $(this).hide()            
      false      

  markOrderAsInStock : () ->   
    $('body').delegate '.mark-supplier-order-as-in-stock  ', 'click', ->      
      dataElement = $(this).parents(".data")
      orderId     = $(dataElement).attr("data-order-id")
      inStock     = $(dataElement).attr("data-status-stock")
      justNow     = $(dataElement).attr("data-just-now")      
      
      actions.ajax 'get', "/supplier_orders/mark_order_as_in_stock/#{orderId}", ""  

      $(dataElement).find('.status').html(inStock)
      $(dataElement).find('.delivery').html(justNow)      

      $(this).hide()            
      false      
    
  markOrderAsOutOfStock : () ->   
    $('body').delegate '.mark-supplier-order-as-out-of-stock  ', 'click', ->      

      dataElement = $(this).parents(".data")
      orderId     = $(dataElement).attr("data-order-id")
      outStock    = $(dataElement).attr("data-status-out-stock")

      actions.ajax 'get', "/supplier_orders/mark_order_as_out_of_stock/#{orderId}", ""  

      $(dataElement).find('.status').html(outStock)

      $(this).hide()            
      false
      
        
  init : () ->         
    supplierOrder.markOrderAsSent()
    supplierOrder.markOrderAsInStock()
    supplierOrder.markOrderAsOutOfStock()
    supplierOrder.calculateSupplierOrderPrice()


jQuery ($) ->
  supplierOrder.init()