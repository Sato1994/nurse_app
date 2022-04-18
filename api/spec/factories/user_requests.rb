# frozen_string_literal: true

FactoryBot.define do
  factory :user_request do
    start_time { 21.hours.from_now }
    finish_time { 29.hours.from_now }
    association :user
    association :recruitment_time

    trait :skip_validate do
      to_create { |user_request| user_request.save(validate: false) }
    end
  end
end
