# frozen_string_literal: true

FactoryBot.define do
  factory :cancell_comment do
    comment { 'こんにちは' }
    association :agreement
  end
end
