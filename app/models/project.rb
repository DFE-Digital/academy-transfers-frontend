class Project
  include ActiveModel::Model

  SAVE_URL = "https://academy-transfers-prototype-api.london.cloudapps.digital/projects".freeze

  STATUS = {
    in_progress: 1,
    completed: 2,
  }.freeze

  ESFA_REASONS = {
    1 => "Governance Concerns",
    2 => "Finance Concerns",
    3 => "Irregularity Concerns",
    4 => "Safeguarding Concerns",
  }.freeze

  RSC_REASONS = {
    1 => "Termination Warning Notice",
    2 => "RSC Minded to Terminate Notice",
    3 => "Ofsted Inadequate Rating",
  }.freeze

  attr_accessor :project_id, :project_name, :project_initiator_full_name, :project_initiator_uid, :project_status,
                :esfa_intervention_reasons, :esfa_intervention_reasons_explained, :rdd_or_rsc_intervention_reasons,
                :rdd_or_rsc_intervention_reasons_explained, :academy_ids, :outgoing_trust_id, :incoming_trust_id

  def save
    token = BearerToken.token
    Faraday.post(SAVE_URL, api_payload.to_json, "Content-Type" => "application/json") do |req|
      req.headers["Authorization"] = "Bearer #{token}"
    end
  end

  def api_payload
    {
      project_initiator_uid: project_initiator_uid,
      project_initiator_full_name: project_initiator_full_name,
      project_status: project_status,
      project_academies: project_academies,
      project_trusts: [
        { trust_id: incoming_trust_id },
      ],
    }.deep_transform_keys { |key| key.to_s.camelize(:lower) }
  end

  def project_academies
    academy_ids.map do |academy_id|
      {
        academy_id: academy_id,
        esfa_intervention_reasons: esfa_intervention_reasons&.select(&:present?),
        esfa_intervention_reasons_explained: esfa_intervention_reasons_explained,
        rdd_or_rsc_intervention_reasons: rdd_or_rsc_intervention_reasons&.select(&:present?),
        rdd_or_rsc_intervention_reasons_explained: rdd_or_rsc_intervention_reasons_explained,
        trusts: [
          { trust_id: outgoing_trust_id },
        ],
      }
    end
  end
end
