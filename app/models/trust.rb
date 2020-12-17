class Trust
  include ActiveModel::Model

  SEARCH_URL = "https://academy-transfers-prototype-api.london.cloudapps.digital/trusts"

  attr_accessor :id, :trust_name, :companies_house_number, :trust_reference_number, :address,
                :establishment_type, :establishment_type_group, :ukprn, :upin

  class << self
    def search(content)
      token = BearerToken.token
      response = Faraday.get(SEARCH_URL, search: content) do |req|
        req.headers['Authorization']="Bearer #{token}"
      end
      payload = JSON.parse(response.body)
      payload.map { |input| new(input) }
    end
  end

  def initialize(attributes = {})
    attributes.transform_keys! {|key| key.to_s.underscore}
    super
  end
end