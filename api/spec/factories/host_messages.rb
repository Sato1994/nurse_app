FactoryBot.define do
  factory :host_message do
    message { Faker::Quote.matz }
    association :room    
  end
end
