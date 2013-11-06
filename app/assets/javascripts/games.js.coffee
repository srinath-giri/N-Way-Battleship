# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# game variable: to save instance variables from the view
game = {
  player_id: 0
}

# initialize the game variable with instance variables from the view
@initialize_game = (player_id) ->
  game.player_id = player_id

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

@attack_grid_point = (x, y) ->
  $.ajax({
    type: 'put',
    dataType: 'script',
    # url: '/games/calculate_hits/',
    url: '/update/'  + game.player_id + '/' + x + '/' + y + '.json',
    # data: {'x': this.x, 'y': this.y, 'player_id': 1},
    data: {x: this.x, y: this.y, player_id: 1},
    success: (data, textStatus, jqXHR) ->
      attack_grid_point_success(data)

  });

attack_grid_point_success = (data) ->
  1 # code goes here