# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('.claim-identity').live 'click', (event) ->
    url = $(this).attr('url')
    modal = "#claim_identity_intro"
    $(modal).modal('show')
    $(modal).on 'hide', ->
    $(modal).find('a.btn-primary')
    .unbind('click')
    .click (event) ->
      $(modal).modal('hide')
      $.ajax(url).success (response) ->
        $(response).modal('show')
      return false
    return false
