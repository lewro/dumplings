###
  File          Nav JS
  Application   Little factory
  Copyright     All rights reserved by Roman Leinwather - Lewro
  Description
###

@nav =
	topNav : () ->
		$('body').delegate '.top-nav', 'click', ->
			$('#top-nav').show()

		$('body').delegate '.top-nav-close', 'click', ->
			$('#top-nav').hide()

	init : () ->
		nav.topNav()

jQuery ($) ->
  nav.init()