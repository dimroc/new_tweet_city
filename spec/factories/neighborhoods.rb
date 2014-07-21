FactoryGirl.define do
  factory :neighborhood do
    name { Faker::Address.city }
    borough { "Manhattan" }
    geometry { RGeo::Geos::Factory.new(srid: 3785).point(5,5) }
  end
end
