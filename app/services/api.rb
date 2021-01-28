class Api
  def self.get(*args)
    new(*args).get
  end

  def self.post(*args)
    new(*args).post
  end

  attr_reader :url, :query

  def initialize(url, query = nil)
    @url = url
    @query = query
  end

  def get
    Faraday.get(url, query) do |req|
      req.headers["Authorization"] = "Bearer #{bearer_token}"
    end
  end

  def post
    Faraday.post(url, query.to_json, "Content-Type" => "application/json") do |req|
      req.headers["Authorization"] = "Bearer #{bearer_token}"
    end
  end

  def bearer_token
    BearerToken.token
  end
end
