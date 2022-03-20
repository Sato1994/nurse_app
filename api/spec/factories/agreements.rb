# frozen_string_literal: true

FactoryBot.define do
  factory :agreement do
    association :user
    association :host
    association :room
    start_time { 24.hours.from_now.change(usec: 0) }
    finish_time { 32.hours.from_now.change(usec: 0) }
    state { 0 }
  end
end
