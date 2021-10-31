FactoryBot.define do
  factory :agreement do
    association :user
    association :host
    start_time { Time.current + 24.hour }
    finish_time { Time.current + 32.hour }
    state { 0 }
  end
end
