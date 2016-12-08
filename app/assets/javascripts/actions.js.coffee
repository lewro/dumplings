###
  File          Actions
  Application   Little Factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@actions =

  ajax : (type, url, returnDataPlaceholder) ->

    $.ajaxSetup headers:
      "X-CSRF-Token": $("meta[name=\"csrf-token\"]").attr("content")

    $.ajax
      type : type
      url : url
      dataType : 'html'
      beforeSend : (jqXHR) ->
        actions.cursorWait()
      complete : (jqXHR) ->
        actions.cursorAuto()
      success : (data) ->
        if typeof returnDataPlaceholder == 'string'
              
          #If return placeholdr contains append keyword, append the results 
          if returnDataPlaceholder.indexOf("&&append") >= 0
            returnDataPlaceholder = returnDataPlaceholder.replace('&&append','')
            $(returnDataPlaceholder).append data
          else
            $(returnDataPlaceholder).html data          
        else
          $(returnDataPlaceholder).html data
                  
        actions.cursorAuto()
        core.init()        
        
      error : (xhr) ->
        actions.cursorAuto()      
          
  cursorWait : ->
    $('html, body').css("cursor", "wait");

  cursorAuto : ->
    $('html, body').css("cursor", "auto");
              