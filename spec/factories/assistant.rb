FactoryBot.define do
  factory :assistant do
    name { Faker::Name.first_name }
    group { "group 2" }
    address { Faker::Address.full_address }
    phone { Faker::Number.number(digits: 10) }
  end
end