def mock_bearer_token_retrieval(access_token = SecureRandom.uuid)
  stub_request(:post, BearerToken::SOURCE_URL).to_return(body: { access_token: access_token }.to_json)
end

def mock_trust_search(search_string, trusts_to_return)
  uri = URI(Trust::SEARCH_URL)
  uri.query = "search=#{search_string}"
  mock_bearer_token_retrieval(mock_api_access_token)

  body = trusts_to_return.map { |trust| camelcase_attributes(trust) }

  stub_request(:get, uri.to_s)
    .with(headers: { "Authorization" => "Bearer #{mock_api_access_token}" })
    .to_return(body: body.to_json)
end

def mock_trust_find(trust)
  url = File.join(Trust::SEARCH_URL, trust.id)
  mock_bearer_token_retrieval(mock_api_access_token)
  body = camelcase_attributes(trust)

  stub_request(:get, url)
    .with(headers: { "Authorization" => "Bearer #{mock_api_access_token}" })
    .to_return(body: body.to_json)
end

def mock_academies_belonging_to_trust(trust, academies)
  url = File.join(Trust::SEARCH_URL, trust.id, "academies")
  mock_bearer_token_retrieval(mock_api_access_token)
  body = academies.map { |academy| camelcase_attributes(academy) }

  stub_request(:get, url)
    .with(headers: { "Authorization" => "Bearer #{mock_api_access_token}" })
    .to_return(body: body.to_json)
end

def mock_project_save(project, response_body = {})
  url = Project::PROJECTS_URL
  mock_bearer_token_retrieval(mock_api_access_token)

  stub_request(:post, url)
    .with(
      body: project.api_payload.to_json,
      headers: { "Authorization" => "Bearer #{mock_api_access_token}" },
    ).to_return(body: response_body)
end

def mock_project_search(projects_to_return, args = {})
  mock_bearer_token_retrieval(mock_api_access_token)
  args.transform_keys! { |key| key.to_s.camelize(:lower) }
  uri = URI(Project::PROJECTS_URL)
  uri.query = args.to_query

  projects = projects_to_return.map { |project| camelcase_attributes(project) }
  body = { projects: projects }

  stub_request(:get, uri.to_s)
    .with(headers: { "Authorization" => "Bearer #{mock_api_access_token}" })
    .to_return(body: body.to_json)
end

def mock_api_access_token
  @mock_api_access_token ||= SecureRandom.uuid
end

def camelcase_attributes(model)
  model.as_json.transform_keys { |key| key.camelcase(:lower) }
end
