# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('#claim-identity').live 'click', (event) ->
    url = $(this).attr('url') + '?user_handle=' + escape($('#user_handle').val())
    $.ajax(url).success (response) ->
      $(response).modal('show')
    return false
