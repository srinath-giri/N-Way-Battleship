# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    id 1
    number_of_players 4
    game_status 'waiting'
    creator 'Luxana'
  end
end
