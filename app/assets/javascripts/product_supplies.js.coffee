###
  File          Prodcut Supplies JS
  Application   Littl factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@productSupply =

  #Remove Product Supply via AJAX
  removeProdcutSupply: () ->
    $('body').delegate '.remove-product-supply', 'click', ->
      
      message = $(this).attr("remove-message")      
      result  = confirm(message)
      
      if result == true
        
        id = $(this).parents('.product').data("product-supply-id")
          
        actions.ajax 'delete', "/product_supplies/#{id}", ""      
        $(this).parents('.product').remove()


  #Add New Invoice Product on NEW View
  addNewProductSupply : () ->  
    $('body').delegate '#add-new-product-supply', 'click', ->

      newProduct = $('#product-supplies .product:last').clone()
      $(newProduct).appendTo('#product-supplies')

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
        $(this).remove()
      $(".product:last").find('select, input').show()

      #Reinitiate the UI
      core.init()             
      
    #Add New Product Supply on Edit View
    $('body').delegate '#add-new-product-supply-edit', 'click', ->
      $(this).hide()      
      hiddenForm = $(".hidden-form").show()
      $("#hiden-form-cover").append(hiddenForm)
      core.init()             
      
  init : () ->            
    productSupply.removeProdcutSupply()
    productSupply.addNewProductSupply()    

jQuery ($) ->
  productSupply.init()
