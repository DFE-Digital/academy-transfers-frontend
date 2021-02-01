class Trust
  include ActiveModel::Model

  SEARCH_URL = File.join(Rails.configuration.x.api.root_url, "trusts").freeze

  attr_accessor :id, :trust_name, :companies_house_number, :trust_reference_number, :address,
                :establishment_type, :establishment_type_group, :ukprn, :upin

  class << self
    def search(content)
      payload = BlockCache.with(content, namespace: :trusts) do
        response = Api.get(SEARCH_URL, search: content)
        raise "API call to /trusts to search for \"#{content}\" failed with: #{response.body}" unless response.success?

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
        url = File.join(SEARCH_URL, id)
        response = Api.get(url)
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
