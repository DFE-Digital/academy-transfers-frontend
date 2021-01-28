class Academy
  include ActiveModel::Model

  attr_accessor :id, :parent_trust_id, :academy_name, :urn, :address, :establishment_type, :local_authority_number,
                :local_authority_name, :religious_character, :diocese_name, :religious_ethos, :ofsted_rating,
                :ofsted_inspection_date, :pfi

  class << self
    def belonging_to_trust(trust_id)
      url = File.join(Trust::SEARCH_URL, trust_id, "academies")
      response = Api.get(url)
      payload = JSON.parse(response.body)
      payload.map { |input| new(input) }
    end
  end

  def initialize(attributes = {})
    attributes.transform_keys! { |key| key.to_s.underscore }
    super
  end

  def academy_name_with_urn
    return academy_name if urn.blank?

    "#{academy_name} (URN #{urn})"
  end

  def ofsted_inspection_date_formatted
    return if ofsted_inspection_date.blank?

    Date.parse(ofsted_inspection_date).to_s(:govuk)
  end
end
