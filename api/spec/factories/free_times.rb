FactoryBot.define do
  factory :free_time do
    association :user
    start_time { Time.current + 20.hour }
    finish_time { Time.current + 30.hour }
  end
end
