module RedisMethods
  def redis
    @redis ||= Redis.new(redis_credentials)
  end

  def redis_credentials
    vcap_services = ENV["VCAP_SERVICES"]
    return {} if vcap_services.blank?

    @redis_credentials ||= begin
      credentials = JSON.parse(vcap_services)
      url = credentials.dig("redis", 0, "credentials", "uri")
      url ? { url: url } : {}
    end
  end
end
