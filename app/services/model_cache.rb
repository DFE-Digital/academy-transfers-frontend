# A cache mechanism to store a Model instance's data after retrieval from the API.
module ModelCache
  EXPIRY = 5.minutes

  extend RedisMethods

  def self.set(model)
    redis_key = key_for(model.id)
    redis.set redis_key, model.to_json
    redis.expire(redis_key, EXPIRY)
  end

  def self.get(model_id)
    data = redis.get(key_for(model_id))
    return unless data

    JSON.parse(data)
  end

  def self.key_for(uuid)
    [Rails.env, "model_cache", uuid].join("_")
  end
end
