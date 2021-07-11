FactoryBot.define do
  factory :recruitment_time do
    association :host
    start_time { Time.current + 20.hour }
    finish_time { Time.current + 30.hour }
  end
end
