FactoryBot.define do
  factory :academy do
    id { SecureRandom.uuid }
    academy_name { Faker::Educator.secondary_school }
    urn { Faker::Number.number(digits: 6).to_s }
    address { Faker::Address.full_address }
    establishment_type { Faker::University.suffix }
    local_authority_number { Faker::Number.number(digits: 3).to_s }
    local_authority_name { Faker::Address.community }
    religious_character { "None" }
    diocese_name { "Not applicable" }
    religious_ethos { "Does not apply" }
    ofsted_rating { ["Outstanding", "Good", "Requires Improvement", "Inadequate"].sample }
    ofsted_inspection_date { Faker::Date.backward(days: 100).to_time.to_json }
  end
end
