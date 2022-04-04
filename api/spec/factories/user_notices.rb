# frozen_string_literal: true

# host requestに関連付ける場合
FactoryBot.define do
  factory :user_notice do
    action { %w[created left agreed changed cancelled].sample }
    checked { false }
    association :source, factory: :host_request
    association :user
  end
end
