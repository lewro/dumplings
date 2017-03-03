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
      if $(this).find('.link-button').length > 0 or $(this).find('.circle-button').length > 0
        #Ignore clicks when button inside
      else
        window.location = $(this).parents('tr').attr("data-link")
    return

  #Top messages
  messages: () ->
    if $.trim($('.notice').html()).length > 0
      $('.notice').slideDown('slow').delay(5000).slideUp('slow')

    if $.trim($('.alert').html()).length > 0
      $('.alert').slideDown('slow').delay(20000).slideUp('slow')


  #Make half boxes equal
  halfBoxes : () ->
    $('.page-content').each ->

      first_page    = $('.half-page:first')
      last_page     = $('.half-page:last')
      first_height  = $(first_page).find('.content').height() + 100
      last_height   = $(last_page).find('.content').height() + 100

      if first_height > last_height
        $(first_page).height(first_height)
        $(last_page).height(first_height)
      else
        $(first_page).height(last_height)
        $(last_page).height(last_height)


  # Switch Buttons - uses Switchable plugin
  switchButtons: () ->
    $("input[type='checkbox']:visible").switchable()

  uiElements : () ->
    $(".datepicker" ).datepicker({
      dateFormat: 'yy-mm-dd'
    })

    $("select:visible").selectmenu()

    #Tooltip
    $( document ).tooltip();


  fixUiElements : () ->
    $(".ui-selectmenu-button").each ->
      widthSize = $(this).parents("div").css("width")
      $(this).css("width", widthSize)



  formSubmit : () ->
    $("form").on 'submit', (e) ->
      core.validateForm(this)

  ajaxList : () ->
    $('body').delegate '[data-ajax-list-button="true"]', 'click', ->

      form        = $(this).parents('[data-ajax-list="true"]')
      url         = $(form).attr("data-ajax-url")
      object      = $(form).attr("data-ajax-object")

      url     = url + "/?"

      $(form).find('[data-ajax-list-element="true"]').each ->
        model   = $(this).attr("data-ajax-element")
        val     = $(this).find("input").val()

        url = url + object+"["+model+"="+val+"]&"

      actions.ajax("get", url, $('.notice'))

  autosubmitLink : () ->
    if $(".autosubmit").length > 0
      url  = $(".autosubmit").data("url")
      win = window.open url, '_blank'

      if (win)
          win.focus();
      else
        alert('Please allow popups for this website');

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


  #Refresh current view when creating new PDF document so the list of files is actual
  refreshOnNewTarget : () ->
    $('body').delegate '.link-button', 'click', ->
      if $(this).attr('target') == '_blank'
        setTimeout (->
          location.reload();
          return
        ), 2000

  callAjaxRefresh : () ->
    $('body').delegate '.ajax-refresh', 'click', ->
      core.addParamToUrl("?email_pdf=true")
      actions.ajax "get", $(this).attr("data-url"), ""
      core.working()
      delay.setTimeout (->
        location.reload();
        return
      ), 2000

  working: () ->
    $("body").addClass("opacity")

  min_size : (element, size) ->
    if $(element).val().length > size
      @validate element
    else
      @invalidate element

  #Not using this, when inline forms showned this does not make sense
  focusFirstInput : () ->
    inputs = $('.page-content .half-page:first').find('input[type=text]')
    inputs.each ->
      if $(this).hasClass('datepicker')
      else
        $(this).focus()
        false

  getUrlVar : (key) ->
    result = new RegExp(key + '=([^&]*)', 'i').exec(window.location.search)
    result and unescape(result[1]) or ''

  addParamToUrl : (param) ->
    window.location.href = window.location.href + param

  clearAllParamsFromUrl : () ->
    # get the string following the ?
    query = window.location.search.substring(1)
    # is there anything there ?
    if query.length
      # are the new history methods available ?
      if window.history != undefined and window.history.pushState != undefined
        # if pushstate exists, add a new state the the history, this changes the url without reloading the page
        window.history.pushState {}, document.title, window.location.pathname

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
    core.switchButtons()
    core.autosubmitLink()
    core.refreshOnNewTarget()
    core.ajaxList()
    core.callAjaxRefresh()

  windowResize : () ->
    $(window).resize ->
      core.uiRepaint()
      core.fixUiElements()

  init : () ->
    core.uiRepaint()
    core.windowResize()

jQuery ($) ->
  core.init()
