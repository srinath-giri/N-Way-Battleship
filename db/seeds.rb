# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


player1 = Player.create(name: "A", turn: true )
player2 = Player.create(name: "B", turn: false )
player3 = Player.create(name: "C", turn: false )
player4 = Player.create(name: "D", turn: false )
