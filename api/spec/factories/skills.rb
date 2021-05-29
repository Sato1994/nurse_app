FactoryBot.define do
  factory :skill do
    name { Faker::Lorem.characters(number: 15) }
  end
end
