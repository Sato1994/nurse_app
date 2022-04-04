# frozen_string_literal: true

# user requestに関連付ける場合
FactoryBot.define do
  factory :host_notice do
    action { %w[created left agreed changed cancelled].sample }
    checked { false }
    association :source, factory: :user_request
    association :host
  end
end
