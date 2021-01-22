require "rails_helper"

RSpec.describe ModelCache do
  let(:trust) { build :trust }
  let(:redis) { described_class.redis }
  let(:redis_key) { "test_model_cache_#{trust.id}" }

  before { redis.del(redis_key) }

  describe ".set" do
    it "caches the model" do
      described_class.set(trust)
      expect(redis.get(redis_key)).to eq(trust.to_json)
    end
  end

  describe ".get" do
    it "returns nil" do
      expect(described_class.get(trust.id)).to be_nil
    end

    context "when a model is cached" do
      it "returns the model data" do
        described_class.set(trust)
        expect(described_class.get(trust.id)).to eq(trust.as_json)
      end
    end
  end
end
