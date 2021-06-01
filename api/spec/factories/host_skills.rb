FactoryBot.define do
  factory :host_skill do
    association :host
    association :skill
  end
end
