# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :grid do
    player_id 1
    grid_type "battlefield"
  end

  factory :battlefield_grid, class: Grid do
    player_id 1
    grid_type "battlefield"
  end

  factory :my_ships_grid, class: Grid do
    player_id 1
    grid_type "my_ships"
  end

end
