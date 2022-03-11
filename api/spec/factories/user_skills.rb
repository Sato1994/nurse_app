# frozen_string_literal: true

FactoryBot.define do
  factory :user_skill do
    association :user
    association :skill
  end
end
