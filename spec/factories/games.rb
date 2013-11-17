# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    number_of_players 4
    game_status 'waiting'
  end
end
