# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player do
    name "Player"
    turn true
    email "player@email.com"
    password "1234567890"
    game_id 1
  end

  factory :player1, class: Player do
    name "Annie"
    turn true
    email "player1@email.com"
    password "1234567890"
    game_id 1
  end

  factory :player2, class: Player do
    name "Twisted Fate"
    turn true
    email "player2@email.com"
    password "1234567890"
    game_id 1
  end

  factory :player3, class: Player do
    name "Nocturne"
    turn true
    email "player3@email.com"
    password "1234567890"
    game_id 1
  end

  factory :player4, class: Player do
    name "Katarina"
    turn true
    email "player4@email.com"
    password "1234567890"
    game_id 1
  end

end

