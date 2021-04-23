FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Internet.free_email }
    password { "password" }
  end
end
