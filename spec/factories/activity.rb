FactoryBot.define do
  factory :activity do

    name { Faker::Job.title }
    description { Faker::Lorem.paragraph }
  end
end