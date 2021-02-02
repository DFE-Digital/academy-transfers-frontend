class Project
  include ActiveModel::Model

  PROJECTS_URL = File.join(Rails.configuration.x.api.root_url, "projects").freeze

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

  API_SEARCH_ARGS = %w[searchTerm status ascending pageSize pageNumber].freeze

  attr_accessor :project_id, :project_name, :project_initiator_full_name, :project_initiator_uid, :project_status,
                :esfa_intervention_reasons, :esfa_intervention_reasons_explained, :rdd_or_rsc_intervention_reasons,
                :rdd_or_rsc_intervention_reasons_explained, :academy_ids, :outgoing_trust_id, :incoming_trust_id

  class << self
    def completed(args = {})
      search(args.merge(status: STATUS[:completed]))
    end

    def in_progress(args = {})
      search(args.merge(status: STATUS[:in_progress]))
    end

    def search(args = {})
      query = args.transform_keys { |key| key.to_s.camelize(:lower) }
      query.slice!(*API_SEARCH_ARGS)
      response = Api.get(PROJECTS_URL, query)
      data = JSON.parse(response.body)
      data["projects"].map { |project_data| new(project_data) }
    end
  end

  def initialize(attributes = {})
    attributes.transform_keys! { |key| key.to_s.underscore }
    super
  end

  def save
    Api.post(PROJECTS_URL, api_payload)
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

  def status_key
    STATUS.invert[project_status]
  end
end
