# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Internet.free_email }
    myid { Faker::Lorem.characters(number: 10) }
    password { 'password' }
    lat { "35.#{rand(100000..999999)}".to_f }
    lng { "139.7#{rand(10000..99999)}".to_f }
  end
end
