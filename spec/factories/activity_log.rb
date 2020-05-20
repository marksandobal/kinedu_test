FactoryBot.define do
  factory :activity_log do
    baby
    assistant
    activity
    start_time { DateTime.now -1.hour }
    stop_time { }
    duration { 55 }
    comments  { Faker::Lorem.paragraph }
  end
end