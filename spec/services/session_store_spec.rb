require "rails_helper"

RSpec.describe SessionStore do
  let(:user) { create :user }
  let(:trust) { build :trust }
  let(:session_store) { described_class.new(user, trust.id) }
  let(:academies) { build_list :academy, 2 }
  let(:data) { academies.map(&:id) }
  let(:in_redis) { JSON.parse(described_class.redis.get(session_store.redis_key)) }

  after do
    described_class.redis.del(session_store.redis_key)
  end

  describe "#store" do
    it "is empty initially" do
      expect(session_store.store).to eq({})
    end

    context "with stored data" do
      let(:data) { SecureRandom.uuid }
      before { described_class.redis.set(session_store.redis_key, data.to_json) }

      it "returned stored data" do
        expect(session_store.store).to eq(data)
      end
    end
  end

  describe "#set" do
    it "stores ids" do
      session_store.set :selected_academies, data
      expect(session_store.store[:selected_academies]).to eq(data)
    end

    it "updates redis" do
      session_store.set :selected_academies, data
      expect(in_redis["selected_academies"]).to eq(data)
    end
  end

  describe "#get" do
    it "returns nil if no data present" do
      expect(session_store.get(:selected_academies)).to be_nil
    end

    context "with data stored" do
      before { session_store.set :selected_academies, data }

      it "returns the stored data" do
        expect(session_store.get(:selected_academies)).to eq(data)
      end
    end

    context "with data already in store" do
      let(:data) { { foo: SecureRandom.uuid } }
      before { described_class.redis.set(session_store.redis_key, data.to_json) }

      it "returns the stored value" do
        expect(session_store.get(:foo)).to eq(data[:foo])
      end
    end
  end
end
