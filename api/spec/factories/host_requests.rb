FactoryBot.define do
  factory :host_request do
    start_time { Time.current + 21.hour }
    finish_time { Time.current  + 29.hour }
    association :host
    association :free_time
  end
end
