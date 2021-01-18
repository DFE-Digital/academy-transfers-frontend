FactoryBot.define do
  factory :project do
    project_id { SecureRandom.uuid }
    project_name { Faker::Company.catch_phrase }
    project_initiator_full_name { Faker::Internet.safe_email }
    project_initiator_uid { SecureRandom.uuid }
    project_status { [1, 2].sample }
    esfa_intervention_reasons { [(1..4).to_a.sample] }
    esfa_intervention_reasons_explained { Faker::Lorem.paragraph }
    rdd_or_rsc_intervention_reasons { [(1..3).to_a.sample] }
    rdd_or_rsc_intervention_reasons_explained { Faker::Lorem.paragraph }
    academy_ids { [SecureRandom.uuid] }
    outgoing_trust_id { SecureRandom.uuid }
    incoming_trust_id { SecureRandom.uuid }
  end
end
