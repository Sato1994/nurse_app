# frozen_string_literal: true

FactoryBot.define do
  factory :host_request do
    start_time { 21.hours.from_now }
    finish_time { 29.hours.from_now }
    association :host
    association :free_time

    trait :skip_validate do
      to_create { |host_request| host_request.save(validate: false) }
    end
  end
end
