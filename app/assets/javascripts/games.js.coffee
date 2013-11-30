# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# game variable: to save instance variables from the view

game = {}
 
# initialize the game variable with instance variables from the view
@initialize_game = (object) ->
  if (object.player_id)
    game.player_id = object.player_id
  if (object.game_id)
    game.game_id =  object.game_id
  if (object.number_of_players)
    game.number_of_players = object.number_of_players


@refresh = ->
  $.ajax "/refresh/" + game.player_id + ".json",
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
  if (player_in_turn.id != game.player_id)
    document.getElementById("player_in_turn_info").innerHTML = "Player moving: " + player_in_turn.name
  else
    document.getElementById("player_in_turn_info").innerHTML = ""


@refresh_waiting_view = ->
  $.ajax
    type: "GET"
    dataType: "json"
    url: "/refresh_waiting_view/",
    data: {game_id: game.game_id},
    error: (jqXHR, textStatus, errorThrown) ->
      $('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      display_players_joining_game(data['players_who_joined'])
      update_waiting_notice(data['players_who_joined'].length)


display_players_joining_game = (players_who_joined) ->
  document.getElementById("players_joining_game").innerHTML = ""
  document.getElementById("players_joining_game").innerHTML += player.name + "<br>" for player in players_who_joined


update_waiting_notice = (players_who_joined) ->
  document.getElementById("waiting_notice").innerHTML = "Waiting for " + (game.number_of_players - players_who_joined) + " players to join the game..."
