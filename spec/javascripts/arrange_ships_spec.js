

describe("@initialize_game function", function() {
    it("returns a game variable with the player_id", function() {
        game = initialize_game(9)
        expect(game.player_id).toEqual(9);
    });
});



//describe("placeShips function", function() {
//    it("puts the letter of the ship in the beginning coordinate", function() {
//        placeShips("Destroyer","Vertical", 0,0)
//        //grid = document.getElemb
//        expect(table.coordinates[x][i].innerHTML).toEqual("D");
//    });
//});

