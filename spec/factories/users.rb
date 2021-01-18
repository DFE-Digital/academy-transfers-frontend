FactoryBot.define do
  factory :user do
    username { Faker::Name.name.gsub(/\s/, ".") }
    uid { SecureRandom.uuid }
  end
end
