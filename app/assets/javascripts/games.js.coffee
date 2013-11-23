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
    data: {x: this.x, y: this.y, player_id: game.player_id},
    success: (data, textStatus, jqXHR) ->
      attack_grid_point_success(data)

  });

attack_grid_point_success = (data) ->
  


@load_battlefield = ->
alert gon.battlefield_cells[0].state[:1]
table = document.getElementById("1")
coordinate(table)
cells = table.getElementsByTagName("td")
for (i=0,td; td=cells[i]; ++i)
{
state  = JSON.stringify(gon.battlefield_cells[i].state);
if(state.indexOf('h') != -1)
table.coordinates[cells[i].x][cells[i].y].innerHTML="<p style='background-color: red'>&nbsp;</p>";
else if(state.indexOf('u') != -1)
table.coordinates[cells[i].x][cells[i].y].innerHTML="<p style='background-color: grey'>&nbsp;</p>";
else if(state.indexOf('m') != -1)
table.coordinates[cells[i].x][cells[i].y].innerHTML="<p style='background-color: green'>&nbsp;</p>";
}
	





@initShipsGrid = ->
alert gon.battlefield_cells[0].state[:1]
table = document.getElementById("2")
coordinate(table)
cells = table.getElementsByTagName("td")

for (i=0,td; td=cells[i]; ++i)
	if(gon.my_ships_grid_cells[i]!=null)
    {
    state = JSON.stringify(gon.my_ships_grid_cells[i].state['hit'])

    if(state.indexOf("true") != -1)
      table.coordinates[gon.my_ships_grid_cells[i].x][gon.my_ships_grid_cells[i].y].innerHTML="<p style='background-color: red'>&nbsp;</p>";
    else if(state.indexOf("false") != -1)
      table.coordinates[gon.my_ships_grid_cells[i].x][gon.my_ships_grid_cells[i].y].innerHTML="<p style='background-color: green'>&nbsp;</p>";
    else
      table.coordinates[gon.my_ships_grid_cells[i].x][gon.my_ships_grid_cells[i].y].innerHTML="<p style='background-color: white'>&nbsp;</p>";
    }


