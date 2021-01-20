class Trust
  include ActiveModel::Model

  SEARCH_URL = File.join(Rails.configuration.x.api.root_url, "trusts").freeze

  attr_accessor :id, :trust_name, :companies_house_number, :trust_reference_number, :address,
                :establishment_type, :establishment_type_group, :ukprn, :upin

  class << self
    def search(content)
      token = BearerToken.token
      payload = BlockCache.with(content, namespace: :trusts) do
        response = Faraday.get(SEARCH_URL, search: content) do |req|
          req.headers["Authorization"] = "Bearer #{token}"
        end
        response.body
      end
      payload = JSON.parse(payload)
      payload.map do |input|
        trust = new(input)
        ModelCache.set(trust)
        trust
      end
    end

    def find(id)
      payload = ModelCache.get(id) || begin
        token = BearerToken.token
        url = File.join(SEARCH_URL, id)
        response = Faraday.get(url) do |req|
          req.headers["Authorization"] = "Bearer #{token}"
        end
        JSON.parse(response.body)
      end

      new(payload)
    end
  end

  def initialize(attributes = {})
    attributes.transform_keys! { |key| key.to_s.underscore }
    super
  end

  def label
    [trust_name, trust_reference_number, companies_house_number].select(&:present?).join(", ")
  end
end
