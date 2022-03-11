# frozen_string_literal: true

FactoryBot.define do
  factory :agreement do
    association :user
    association :host
    association :room
    start_time { 24.hours.from_now }
    finish_time { 32.hours.from_now }
    state { 0 }
  end
end
