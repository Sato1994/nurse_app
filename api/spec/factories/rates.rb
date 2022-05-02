# frozen_string_literal: true

FactoryBot.define do
  factory :rate do
    star { [1, 2, 3, 4, 5].sample }
    comment { 'こんにちは' }
    association :agreement

    trait :skip_validate do
      to_create { |rate| rate.save(validate: false) }
    end
  end
end
