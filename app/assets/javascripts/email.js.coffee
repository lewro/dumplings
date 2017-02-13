###
  File          Email JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@email =

  sendPDF : () ->
    $("body").delegate ".inline-form input.button", "click", ->
      emailForm    = $(this).parents(".email-form")
      dataLink     = emailForm.attr("data-link")
      dataId       = emailForm.attr("data-Id")
      subject      = emailForm.find("#email_subject").val()
      body         = emailForm.find("#email_body").val()
      url          = dataLink + dataId + '?subject=' + subject + '&body=' + body

      actions.ajax 'get', url, $('.notice')
      emailForm.hide()
      false

  showEmailForm : () ->
    $("body").delegate ".fa-envelope-o", "click", ->
      dataId   = $(this).attr("data-id")
      link     = $(this).parents("td").find("a").clone()

      $(".email-form").attr("data-id", dataId)
      $('.email-form').show()
      $(".email-form .pdf-link").html(link)


  hideEmailForm : () ->
    $("body").delegate ".close-email-sidebar", "click", ->
      $(".email-form").hide()

  init : () ->
    email.sendPDF()
    email.showEmailForm()
    email.hideEmailForm()

jQuery ($) ->
  email.init()
