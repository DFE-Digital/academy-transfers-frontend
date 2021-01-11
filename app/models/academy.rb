class Academy
  include ActiveModel::Model

  attr_accessor :id, :parent_trust_id, :academy_name, :urn, :address, :establishment_type, :local_authority_number,
                :local_authority_name, :religious_character, :diocese_name, :religious_ethos, :ofsted_rating,
                :ofsted_inspection_date, :pfi

  class << self
    def belonging_to_trust(trust_id)
      token = BearerToken.token
      url = File.join(Trust::SEARCH_URL, trust_id, "academies")
      response = Faraday.get(url) do |req|
        req.headers["Authorization"] = "Bearer #{token}"
      end
      payload = JSON.parse(response.body)
      payload.map { |input| new(input) }
    end
  end

  def initialize(attributes = {})
    attributes.transform_keys! { |key| key.to_s.underscore }
    super
  end
end
