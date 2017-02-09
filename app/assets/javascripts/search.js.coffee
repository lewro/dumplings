###
  File          Search JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@search =

  search : ->
    $('body').delegate '#search input', 'keyup', (e) ->
      if e.keyCode == 27
        #ingnore escape
      else
        searchValue = $(this).val()
        if searchValue.length > 1
          search.searchAjax searchValue


  searchAjax : (query) ->

    search.searchInProgress()
    category                  = $("#search").attr("data-category")
    type                      = 'get'
    url                       = '/searches/?q=' + query + "&category=" + category
    returnDataPlaceholder     = '[data-ajax-return="search"]'

    actions.ajax(type, url, returnDataPlaceholder)

  onMouseUpSearch : ->
    $(document).mouseup (e) ->
      if $('#search-results').is(':visible') && $(e.target).parents('#search-results').length == 0
        search.clearSearch()

  escapeSearch : ->
    $(document).delegate 'input', 'keyup', (e) ->
      if e.keyCode == 27 #Escape
        search.clearSearch()

  clearSearch : ->
    $('#q').val('')
    $('#search-results').html('')

  searchInProgress : ->
    $("#search .fa-search").hide()
    $("#search .fa-circle-o-notch").show()

  defaultIcons : ->
    $("#search .fa-search").show()
    $("#search .fa-circle-o-notch").hide()

  init : () ->
    search.defaultIcons()
    search.search()
    search.onMouseUpSearch()
    search.escapeSearch()

jQuery ($) ->
  search.init()
