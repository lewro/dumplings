###
  File          Core JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@core =

  #Make table rows clickable
  tableRows : () ->
    $('tr[data-link] td').click ->
      if $(this).find('.link-button').length > 0
        #Ignore clicks when button inside
      else
        window.location = $(this).parents('tr').attr("data-link")
    return

  #Top messages
  messages: () ->    
    if $.trim($('.notice, .alert').html()).length > 0
      $('.notice, .alert').slideDown('slow').delay(5000).slideUp('slow')

  #Make half boxes equal
  halfBoxes : () ->
    $('.page-content').each ->

      first   =  $('.half-page:first .content').height() + 100
      last    =  $('.half-page:last .content').height() + 100

      if first > last
        $('.half-page:first').height(first)        
        $('.half-page:last').height(first)
      else
        $('.half-page:first').height(last)
        $('.half-page:last').height(last)        
      

  uiElements : () ->
    $(".datepicker" ).datepicker({ dateFormat: 'yy-mm-dd' })
    $("select:visible").selectmenu()
    
  fixUiElements : () ->
    $(".ui-selectmenu-button").each -> 
      widthSize = $(this).parents("div").css("width")
      $(this).css("width", widthSize)
    
  formSubmit : () ->
    $("form").on 'submit', (e) ->
      core.validateForm(this)
  
  validateForm : (form) ->
    #Empty Input?
    if $(form).find('input[type="text"]').length > 0

      $(form).find('input[type="text"]').each ->
        if $(this).data("required") == true
          core.not_empty_input $(this)

    if $(form).find('input[type="number"]').length > 0
      $(form).find('input[type="number"]').each ->
        if $(this).data("required") == true
          core.not_empty_input $(this)

    if $(form).find('input[type="password"]').length > 0
      $(form).find('input[type="password"]').each ->
        core.not_empty_input $(this)
        core.min_size $(this), 4

    #Empty Textarea?
    if $(form).find('textarea').length > 0
      $(form).find('textarea').each ->
        if $(this).data("required") == true
          core.not_empty_input $(this)

          #Not too long?
          unless $(this).hasClass('long-text')
            core.max_size $(this)

    #Email?
    if $(form).find('input[type="email"]').length > 0
      $(form).find('input[type="email"]').each ->
        if $(this).data("required") == true
          core.email_valid $(this)

    #Integral?
    if $(form).find('input[type="number"]').length > 0
      $(form).find('input[type="number"]').each ->
        if $(this).data("required") == true
          core.integ_valid $(this)

    if $(form).find('.validation_error').length > 0
      return false
    else
      return true

  invalidate : (element) ->
    $(element).addClass('validation_error')

    #LOG: 11/08/2014 - Showing textarea so the error is visible and hiding container
    if $(element).is('textarea')
      $(element).show()
      $(element).prev('.textarea').hide()

  validate : (element) ->
    $(element).removeClass('validation_error')

  max_size : (element) ->
    filter = new RegExp(/^\s*$/)

    if filter.test $(element).val()
        @invalidate element
    else
      if $(element).val().length < 200
        @validate element
        core.not_empty_input element
      else
        @invalidate element


  not_empty_input : (element) ->
    filter = new RegExp(/^\s*$/)

    if filter.test $(element).val()
      @invalidate element

      #Special case - Calendar
      if $(element).parents('.calendar-content').length == 1
        @invalidate $(element).parents('.calendar-content').prev('.calendar-header')

      #Special case - Drop Down
      if $(element).parents('.hiddenform-item').prev('.drop-down').length > 0
        @invalidate $(element).parents('.hiddenform-item').prev('.drop-down').find('.drop-down-header')

      if $(element).parents('.hiddenform-item').parents('.drop-down').length == 1
        @invalidate $(element).parents('.hiddenform-item').parents('.drop-down').find('.drop-down-header')

    else
      @validate element

      if $(element).parents('.calendar-content').length == 1
        @validate $(element).parents('.calendar-content').prev('.calendar-header')

      if $(element).parents('.hiddenform-item').prev('.drop-down').length == 1
        @validate $(element).parents('.hiddenform-item').prev('.drop-down').find('.drop-down-header')

      if $(element).parents('.hiddenform-item').parents('.drop-down').length == 1
        @validate $(element).parents('.hiddenform-item').parents('.drop-down').find('.drop-down-header')


  email_valid : (element) ->
    filter = new RegExp(/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/)
    if element.hasClass('email-exist')
    else
      if filter.test $(element).val()
        @validate element
      else
          @invalidate element

  integ_valid : (element) ->
    filter = new RegExp(/^([0-9])+$/)
    if filter.test $(element).val()
      @validate element
    else
      @invalidate element
      
  textAreaAutoGrow : () ->
    $('textarea').autogrow()
      
  min_size : (element, size) ->
    if $(element).val().length > size
      @validate element
    else
      @invalidate element

  focusFirstInput : () ->
    inputs = $('.page-content .half-page:first').find('input[type=text]')
    inputs.each ->
      if $(this).hasClass('datepicker')
      else
        $(this).focus()
        false
      
  scroll : () ->
    if $('.scroll').length > 0
      $('.scroll').jScrollPane({
        showArrows: true,
        animateScroll: true,
        contentWidth: '0px',
        verticalGutter: 0,
        horizontalGutter: 0,
        arrowButtonSpeed: 300,
        mouseWheelSpeed: 5
      })      

  uiRepaint : () ->
    core.uiElements()
    core.halfBoxes()      
    core.textAreaAutoGrow()
    core.scroll() 
    core.tableRows()
    core.formSubmit()
    core.messages()  
    
  windowResize : () ->
    $(window).resize ->
      core.uiRepaint()
      core.fixUiElements()

  init : () ->
    core.uiRepaint()    
    core.windowResize()
    core.focusFirstInput()

jQuery ($) ->
  core.init()  