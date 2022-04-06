# frozen_string_literal: true

FactoryBot.define do
  factory :free_time do
    association :user
    start_time { 20.hours.from_now }
    finish_time { 30.hours.from_now }
  end
end
