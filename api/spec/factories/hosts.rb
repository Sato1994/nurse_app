# frozen_string_literal: true

FactoryBot.define do
  factory :host do
    name { "#{Faker::Address.city}モチムギ病院" }
    email { Faker::Internet.free_email }
    myid { Faker::Lorem.characters(number: 10) }
    password { 'password' }
  end
end
