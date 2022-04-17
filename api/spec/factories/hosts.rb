# frozen_string_literal: true

FactoryBot.define do
  factory :host do
    name { "#{Faker::Address.city}モチムギ病院" }
    email { Faker::Internet.free_email }
    myid { Faker::Lorem.characters(number: 10) }
    phone { '02912345678' }
    password { 'password' }
    lat { "35.#{rand(100000..999999)}".to_f }
    lng { "139.7#{rand(10000..99999)}".to_f }
  end
end
