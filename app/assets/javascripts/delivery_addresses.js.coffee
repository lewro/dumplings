###
  File          Delivery Addresses JS
  Application   Littl factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@deliveryAddress =

  #Remove Delivery Address via AJAX
  removeDeliveryAddress: () ->
    $('body').delegate '.remove-delivery-address', 'click', ->
      
      message = $(this).attr("remove-message")      
      result  = confirm(message)
      
      if result == true
        
        id = $(this).parents('.delivery-address').data("delivery-address-id")
          
        actions.ajax 'delete', "/delivery_addresses/#{id}", $('.notice')    
      
        $(this).parents('.delivery-address').remove()


  #Add New Delivery Address on NEW View
  addNewDeliveryAddress : () ->  
    $('body').delegate '#add-new-delivery-address', 'click', ->

      newAddress = $('#delivery-addresses .delivery-address:last').clone()

      $(newAddress).appendTo('#delivery-addresses')      

      #Input
      $(".delivery-address:last").find('input').each ->      
        nameAttr      = $(this).attr('name')
        digit         = parseFloat(nameAttr.match(/\d+/))
        newDigit      = digit + 1

        $(this).attr 'name', (i, old) ->
          old.replace digit, newDigit
        $(this).attr 'id', (i, old) ->
          old.replace digit, newDigit

      #Remove the span elements created by Jqeury UI
      $(".delivery-address:last").find('span').each ->
        unless $(this).hasClass("ui-icon")
          $(this).remove()

      $(".delivery-address:last").find('select, input').show()

      #Remove haDatepicker class to fix the issue with calendar not appearing
      $(".datepicker").removeClass("hasDatepicker")

      #Reinitiate the UI
      core.init()       
      
      
    #Add New Delivery Address on Edit View
    $('body').delegate '#add-new-delivery-address-edit', 'click', ->
      $(this).hide()
      hiddenForm = $(".hidden-form").show()
      $("#hiden-form-cover").append(hiddenForm)
      core.init()             

      
  init : () ->            
    deliveryAddress.removeDeliveryAddress()
    deliveryAddress.addNewDeliveryAddress()    

jQuery ($) ->
  deliveryAddress.init()
