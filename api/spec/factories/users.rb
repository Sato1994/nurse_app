FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Internet.free_email }
    myid { Faker::Lorem.characters(number: 10) }
    password { "password" }
  end
end
