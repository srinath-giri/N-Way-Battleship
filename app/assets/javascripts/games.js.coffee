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
  if (object.players)
    game.players = object.players


@init_cell_events = (table) ->
  cells = table.getElementsByTagName('td');
  for td in  cells
    $(td).click ->
      $.ajax
        url: '/update/'  + game.player_id + '/' + this.x + '/' + this.y + '.json',
        type: 'put',
        dataType: 'script',
        data: {x: this.x, y: this.y, player_id: game.player_id},
        success: (data, textStatus, jqXHR) ->
          display_battlefield_attacked_cell(data['battlefield_cell'],data['other_players'])




# /play/:player_id
# Update the game state
#
@refresh = ->
  $.ajax
    url: "/refresh/" + game.player_id + ".json",
    type: 'GET',
    dataType: 'json',
    error: (jqXHR, textStatus, errorThrown) ->
      $('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      display_turn(data['turn'])
      display_player_in_turn(data['player_in_turn'])
      display_battlefield_attacked_cell(data['battlefield_cell'],data['other_players'])
      display_ship_attacked_cell(data['my_ships_cell'])


display_turn = (turn) ->
  if (turn == true)
    document.getElementById("turn_info").innerHTML = "It's your turn to take a shot"
  else
    document.getElementById("turn_info").innerHTML = "&nbsp;"


display_player_in_turn = (player_in_turn) ->
  if (player_in_turn.id != game.player_id)
    document.getElementById("player_in_turn_info").innerHTML = "Player moving: " + player_in_turn.name
  else
    document.getElementById("player_in_turn_info").innerHTML = "&nbsp;"

display_battlefield_cell_status = (display,status) ->
  if (display == true)
    document.getElementById("cell_status").innerHTML = status
  else
    document.getElementById("cell_status").innerHTML = "&nbsp;"

display_battlefield_attacked_cell = (battlefield_cell,other_players) ->
  table = document.getElementById('1')

  state = JSON.stringify(battlefield_cell.state); #state = "{2:'u',3:'h', 4:'m'}"
  if(state.indexOf('h') != -1)
    table.coordinates[battlefield_cell.x][battlefield_cell.y].className = "cell_hit"
  else if(state.indexOf('m') != -1)
    table.coordinates[battlefield_cell.x][battlefield_cell.y].className = "cell_miss"

  state = state.replace(/"/g,"")
  state = state.replace(/:/g,"")
  state = state.replace(/,/g," ")
  state = state.replace(/{/,"<table>")
  state = state.replace(/}/,"</table>")


  state = state.replace(/h/g,"<td><div class =\"cell_hit\"></div></td></tr>")
  state = state.replace(/m/g,"<td><div class =\"cell_miss\"></div></td></tr>")
  state = state.replace(/u/g,"<td><div class =\"cell_unknown\"></div></td></tr>")

  for player in other_players
    id = player.id
    name = player.name
    state = state.replace(id, "<tr><td>" + name + "</td>" )


  table.coordinates[battlefield_cell.x][battlefield_cell.y].onmouseover = () -> display_battlefield_cell_status(true,state)
  table.coordinates[battlefield_cell.x][battlefield_cell.y].onmouseout = () -> display_battlefield_cell_status(false,state)

display_ship_attacked_cell = (my_ships_cell) ->
  table = document.getElementById('2');
  state = JSON.stringify(my_ships_cell.state['hit']);
  if(state.indexOf("true") != -1)
    table.coordinates[my_ships_cell.x][my_ships_cell.y].className = "cell_destroyed"


@init_battlefield = ->
  table = document.getElementById('1');
  cells = table.getElementsByTagName('td');
  paint_cell cell for cell in cells

paint_cell = (cell) ->
  cell.className = "cell";



# universal battlefield view
# Creates coordinates for the cells of the specified table
#
coordinate = (table) ->
  table.coordinates = [];
  tbody = undefined
  c = undefined

  # Find table body and assign it to tbody
  for n in table.childNodes
    c = table.childNodes[n]
    if (c.tagName && c.tagName.match(/^tbody$/i))
      tbody = c;
      break;

  x = -1
  y = -1

  # Go through each cell to:
  # - Assign each table.coordinates[x][y] = cell
  # - Assign the coordinates of each cell: cell.x = x; cell.y = y
  for rn in tbody.childNodes
    row = tbody.childNodes[rn];
    if (row.tagName && row.tagName.match(/^tr$/i))
      x = -1
      ++y
      for cn in row.childNodes
        col = row.childNodes[cn]
        if (col.tagName && col.tagName.match(/^t[dh]$/i))
          colspan = col.getAttribute('colspan');
          if (! colspan)
            colspan = 1
          while (colspan--)
            ++x
            if (! table.coordinates[x])
              table.coordinates[x] = []
            table.coordinates[x][y] = col
            col.x = x
            col.y = y

  x = 0
  y = 0
  # Go through each cell to:
  # - Assign the cell to the north, south, west and east
  # - Assign css class
  while table.coordinates[x]?
    while table.coordinates[x][y]?
      col=table.coordinates[x][y]
      col.className = "cell"
      col.north = if (y > 0) then table.coordinates[x][y-1] else undefined
      col.south = if (table.coordinates[x][y+1]) then table.coordinates[x][y+1] else undefined
      col.west = if (x > 0) then table.coordinates[x-1][y] else undefined;
      col.east = if (table.coordinates[x+1]) then table.coordinates[x+1][y] else undefined;
      y++
    x++



@refresh_waiting_view = ->
  $.ajax
    type: "GET",
    dataType: "json",
    url: "/refresh_waiting_view/",
    data: {game_id: game.game_id},
    error: (jqXHR, textStatus, errorThrown) ->
      $('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      display_players_joining_game(data['players_who_joined'])
      update_waiting_notice(data['players_who_joined'].length)
      if game_is_full(data['players_who_joined'].length)
        move_to("/arrange_ships/" + game.player_id)



display_players_joining_game = (players_who_joined) ->
  list = "<ol>"
  list += "<li>" + player.name + "</li>" for player in players_who_joined
  list += "</ol>"
  document.getElementById("players_joining_game").innerHTML = list


update_waiting_notice = (players_who_joined) ->
  document.getElementById("waiting_notice").innerHTML = "Waiting for " + (game.number_of_players - players_who_joined) + " players to join the game..."

game_is_full = (players_who_joined) ->
  if  (game.number_of_players - players_who_joined) == 0
    true
  else
    false

move_to = (view_url) ->
  window.location.href = view_url
