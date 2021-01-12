class SessionStore
  EXPIRY = 1.day

  require "concerns/redis_methods"
  extend RedisMethods
  delegate :redis, to: :class

  attr_reader :user, :outgoing_trust_id

  def initialize(user, outgoing_trust_id)
    @user = user
    @outgoing_trust_id = outgoing_trust_id
  end

  def set(key, data)
    store[key] = data
    save!
  end

  def get(key)
    redis_data[key.to_s]
  end

  def redis_key
    @redis_key ||= [Rails.env, "session_store", user.id, outgoing_trust_id].join("_")
  end

  def store
    @store ||= redis_data
  end

  def save!
    redis.set(redis_key, store.to_json)
    redis.expire(redis_key, EXPIRY)
  end

  def redis_data
    data = redis.get(redis_key)
    return {} unless data

    JSON.parse(data)
  end
end
