# frozen_string_literal: true

FactoryBot.define do
  factory :host_request do
    start_time { 21.hours.from_now }
    finish_time { 29.hours.from_now }
    association :host
    association :free_time
  end
end
