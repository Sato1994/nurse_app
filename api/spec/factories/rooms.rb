# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    association :user
    association :host
    start_time { 21.hours.from_now }
    finish_time { 29.hours.from_now }
    state { 0 }
    closed { 0 }
  end
end
