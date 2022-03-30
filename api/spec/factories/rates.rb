# frozen_string_literal: true

FactoryBot.define do
  factory :rate do
    star { [1, 2, 3, 4, 5].sample }
    comment { 'こんにちは' }
    association :agreement
  end
end
