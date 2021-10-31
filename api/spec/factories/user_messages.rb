FactoryBot.define do
  factory :user_message do
    message { Faker::Quote.matz}
    association :room
  end
end
