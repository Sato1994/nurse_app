FactoryBot.define do
  factory :room do
    association :user
    association :host
    start_time { Time.current + 21.hour }
    finish_time { Time.current + 29.hour } 
    consensus { 0 }
    deletion { 0 }
  end
end
