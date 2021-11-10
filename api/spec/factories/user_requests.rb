FactoryBot.define do
  factory :user_request do
    start_time { Time.current + 21.hour }
    finish_time { Time.current + 29.hour }
    association :user
    association :recruitment_time
  end
end
