def mock_bearer_token_retrieval(access_token = SecureRandom.uuid)
  stub_request(:post, BearerToken::SOURCE_URL).to_return(body: { access_token: access_token }.to_json)
end

def mock_trust_search(search_string, trusts_to_return)
  uri = URI(Trust::SEARCH_URL)
  uri.query = "search=#{search_string}"

  access_token = SecureRandom.uuid
  mock_bearer_token_retrieval(access_token)

  body = trusts_to_return.map { |trust| camelcase_attributes(trust) }

  stub_request(:get, uri.to_s)
    .with(headers: { "Authorization" => "Bearer #{access_token}" })
    .to_return(body: body.to_json)
end

def mock_trust_find(trust)
  url = File.join(Trust::SEARCH_URL, trust.id)

  access_token = SecureRandom.uuid
  mock_bearer_token_retrieval(access_token)

  body = camelcase_attributes(trust)

  stub_request(:get, url)
    .with(headers: { "Authorization" => "Bearer #{access_token}" })
    .to_return(body: body.to_json)
end

def mock_academies_belonging_to_trust(trust, academies)
  url = File.join(Trust::SEARCH_URL, trust.id, "academies")

  access_token = SecureRandom.uuid
  mock_bearer_token_retrieval(access_token)

  body = academies.map { |academy| camelcase_attributes(academy) }

  stub_request(:get, url)
    .with(headers: { "Authorization" => "Bearer #{access_token}" })
    .to_return(body: body.to_json)

end

def camelcase_attributes(model)
  model.as_json.transform_keys { |key| key.camelcase(:lower) }
end
