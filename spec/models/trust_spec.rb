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

    it "caches model in redis" do
      results
      key = ModelCache.key_for(trust.id)
      expect(redis.get(key)).to eq(trust.to_json)
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

    context "trust is cached" do
      let(:cached_trust) { build :trust, id: trust.id }
      before { ModelCache.set(cached_trust) }

      it "returns the cached trust" do
        expect(result.as_json).not_to eq(trust.as_json)
        expect(result.as_json).to eq(cached_trust.as_json)
      end
    end
  end

  describe "#label" do
    it "contains name, identifiers" do
      expect(trust.label).to eq("#{trust.trust_name}, #{trust.trust_reference_number}, #{trust.companies_house_number}")
    end
  end
end
