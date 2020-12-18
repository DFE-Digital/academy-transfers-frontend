FactoryBot.define do
  factory :trust do
    id { SecureRandom.uuid }
    trust_name { Faker::Educator.secondary_school }
    companies_house_number { Faker::Number.leading_zero_number(digits: 8) }
    trust_reference_number { "TR#{Faker::Number.decimal_part(digits: 5)}" }
    address { Faker::Address.full_address }
    establishment_type { "Multi-academy trust" }
    establishment_type_group { "Multi-academy trust" }
    ukprn { Faker::Number.leading_zero_number(digits: 8) }
    upin { Faker::Number.leading_zero_number(digits: 6) }
  end
end
