FactoryBot.define do
  factory :baby do

    name { Faker::Name.first_name }
    birthday { Faker::Name.last_name }
    mother_name { Faker::Name.first_name }
    father_name { Faker::Name.first_name }
    address { Faker::Address.full_address }
    phone { Faker::Number.number(digits: 10) }
  end
end