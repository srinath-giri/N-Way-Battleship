# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/




setInterval ->
  refresh()
, 1000

# We need to change the id 1 for the id of the current player
refresh = ->
  $.ajax "/refresh/#{1}.json",
    type: 'GET'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      $('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      display_turn(data['turn'])
      display_player_in_turn(data['player_in_turn'])



display_turn = (turn) ->
  if (turn == true)
    document.getElementById("turn_info").innerHTML = "It's your turn to take a shot"
  else
    document.getElementById("turn_info").innerHTML = ""


display_player_in_turn = (player_in_turn) ->
  if (player_in_turn.id != 1)
    document.getElementById("player_in_turn_info").innerHTML = player_in_turn.name
  else
    document.getElementById("player_in_turn_info").innerHTML = ""



