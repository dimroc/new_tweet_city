# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tweet do
    text { "Irrelevant Gibberish" }
    screen_name { "dimroc" }
  end
end
