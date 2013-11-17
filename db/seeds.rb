# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


player1 = Player.create(name: "A", turn: true, email:"a@email.com", password:"1234567890" )
player2 = Player.create(name: "B", turn: false, email:"b@email.com", password:"1234567890")
player3 = Player.create(name: "C", turn: false, email:"c@email.com", password:"1234567890" )
player4 = Player.create(name: "D", turn: false, email:"d@email.com", password:"1234567890" )
