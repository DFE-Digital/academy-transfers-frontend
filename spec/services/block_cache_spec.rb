require "rails_helper"

RSpec.describe BlockCache do
  let(:payload) { Faker::Lorem.sentence }
  let(:key) { Faker::Lorem.word }
  let(:redis_key) { "test_block_cache_#{key}" }
  let(:redis) { described_class.redis }

  describe ".with" do
    let(:result) do
      described_class.with(key) { payload }
    end

    before { redis.del(redis_key) }

    it "returns payload" do
      expect(result).to eq(payload)
    end

    it "adds payload to redis" do
      result
      expect(redis.get(redis_key)).to eq(payload)
    end

    context "with cached content" do
      let(:cached) { Faker::Lorem.sentence }

      before { redis.set(redis_key, cached) }

      it "returns cached" do
        expect(result).to eq(cached)
      end
    end

    context "with namespace" do
      let(:namespace) { Faker::Lorem.word }
      let(:redis_key) { "test_block_cache_#{namespace}_#{key}" }
      let(:result) do
        described_class.with(key, namespace: namespace) { payload }
      end

      it "returns payload" do
        expect(result).to eq(payload)
      end

      it "adds payload to redis" do
        result
        expect(redis.get(redis_key)).to eq(payload)
      end
    end
  end

  describe ".redis_credentials" do
    it "returns empty hash" do
      expect(described_class.redis_credentials).to eq({})
    end

    context "with credentials in environment variable" do
      let(:url) { Faker::Internet.url }
      let(:credentials) do
        {
          redis: [
            {
              credentials: { uri: url },
            },
          ],
        }
      end
      before do
        allow(ENV).to receive(:[]).with("VCAP_SERVICES").and_return(credentials.to_json)
      end

      it "returns url" do
        expect(described_class.redis_credentials).to eq({ url: url })
      end
    end
  end
end
