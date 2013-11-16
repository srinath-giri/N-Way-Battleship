# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :cell do
    x 1
    y 1
    state ""
    grid_id 1
  end

  battlefield_state = {"2"=>'u', "3"=>'u', "4"=>'u'}
  factory :battlefield_cell, class: Cell do
    x 1
    y 1
    state battlefield_state
    grid { FactoryGirl.create(:battlefield_grid) }
  end

  my_ships_state = {"orientation" => "V", "block" => "1", "type" => "Destroyer", "hit" => false}
  factory :my_ships_cell, class: Cell do
    x 1
    y 1
    state my_ships_state
    grid { FactoryGirl.create(:my_ships_grid) }
  end


end
