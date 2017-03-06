###
  File          Task JS
  Application   Littl factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@task =


  showStockOptions : () ->
    $('body').delegate '#show-stock-option', 'click', ->
      $(this).hide()
      hiddenForm = $("#stock-value").show()
      core.init()

  init : () ->
    task.showStockOptions()

jQuery ($) ->
  task.init()
