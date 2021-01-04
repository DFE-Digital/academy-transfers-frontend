require "rails_helper"

RSpec.describe Trust, type: :model do
  let(:trust) { build :trust }

  describe ".search" do
    let(:query) { Faker::Lorem.word }
    let(:results) { described_class.search(query) }
    let(:redis) { Redis.new }
    let(:redis_key) { "test_block_cache_trusts_#{query}" }

    before do
      redis.del(redis_key)
      mock_trust_search(query, [trust])
    end

    it "returns matching trust" do
      expect(results.length).to eq(1)
      expect(results.first.as_json).to eq(trust.as_json)
    end

    it "caches result in redis" do
      results
      # JSON response is cached so mismatch between keys (camelcase in JSON), so just checking trust id within cached data
      expect(redis.get(redis_key)).to include(trust.id)
    end
  end

  describe ".find" do
    let(:result) { described_class.find(trust.id) }

    before do
      mock_trust_find(trust)
    end

    it "returns the trust" do
      expect(result.as_json).to eq(trust.as_json)
    end
  end
end
