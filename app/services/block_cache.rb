# Used to wrap around a piece of code and cache the outcome of that code.
# So for example:
#
#   result = Blockcache.with(search_string) { search_process(search_string) }
#
# The first time this is called, `search_process` will be called to retrieve a result.
# Until the cache expires the result will be retrieved from cache without calling `search_process`.
#
class BlockCache
  EXPIRY = 5.minutes

  def self.with(key, namespace: nil, &block)
    new(key, namespace: namespace, &block).result
  end

  require "concerns/redis_methods"
  extend RedisMethods
  delegate :redis, to: :class

  attr_reader :key, :namespace, :block

  def initialize(key, namespace: nil, &block)
    @key = key
    @namespace = namespace.to_s
    @block = block
  end

  def redis_key
    @redis_key ||= [Rails.env, "block_cache", namespace, key].select(&:present?).join("_")
  end

  def result
    return cached if cached

    save_live_in_cache
    live
  end

  def cached
    redis.get(redis_key)
  end

  def save_live_in_cache
    redis.set(redis_key, live)
    redis.expire(redis_key, EXPIRY)
  end

  def live
    @live ||= block.call
  end
end
