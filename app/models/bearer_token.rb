class BearerToken
  SOURCE_URL = "https://login.microsoftonline.com/fad277c9-c60a-4da1-b5f3-b3b8b34a82f9/oauth2/v2.0/token"

  def self.token
    new.token
  end

  def token
    json[:access_token]
  end

  def json
    @json ||= JSON.parse(response.body, symbolize_names: true)
  end

  def response
    @response ||= Faraday.post(
      SOURCE_URL,
      grant_type: 'client_credentials',
      scope: Rails.application.credentials.api[:client_scope],
      client_id: Rails.application.credentials.api[:client_id],
      client_secret: Rails.application.credentials.api[:client_secret]
    )
  end
end
