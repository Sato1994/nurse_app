FactoryBot.define do
  factory :room do
    association :user
    association :host
  end
end
