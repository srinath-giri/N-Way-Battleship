# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cell do
    x 1
    y 1
    state "MyString"
    grid_id 1
  end
end
