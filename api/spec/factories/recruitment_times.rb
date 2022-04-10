# frozen_string_literal: true

FactoryBot.define do
  factory :recruitment_time do
    association :host
    start_time { 20.hours.from_now }
    finish_time { 30.hours.from_now }

    trait :skip_validate do
      to_create {|recruitment_time| recruitment_time.save(validate: false)}
    end
  end
end
