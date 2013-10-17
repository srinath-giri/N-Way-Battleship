# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ -> $("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
  if (data['turn'] == true)
    document.getElementById("turn_info").innerHTML = "It's your turn to take a shot"
  else
    document.getElementById("turn_info").innerHTML = ""
