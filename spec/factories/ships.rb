# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ship do
    name "MyString"
    x_start 1
    x_end 1
    y_start 1
    y_end 1
    state "MyText"
  end
end
