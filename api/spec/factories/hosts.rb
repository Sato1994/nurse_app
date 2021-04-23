FactoryBot.define do
  factory :host do
    name { Faker::Address.city + "モチムギ病院" }
    email { Faker::Internet.free_email }
    password { "password" }
  end
end
