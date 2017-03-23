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

  markTaskAsDone : () ->
    $('body').delegate '.mark-task-as-done', 'click', ->
      dataElement = $(this).parents(".data")
      taskId      = $(dataElement).attr("data-task-id")

      actions.ajax 'get', "/tasks/mark_task_as_done/#{taskId}", ""

      $(this).parents(".data").hide()
      false

  init : () ->
    task.showStockOptions()
    task.markTaskAsDone()

jQuery ($) ->
  task.init()
