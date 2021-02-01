require "rails_helper"

RSpec.describe "/trusts", type: :request do
  describe "GET /" do
    let(:query) { Faker::Educator.secondary_school }
    let(:trust) { build :trust, trust_name: "#{query} one" }
    let(:trust_two) { build :trust, trust_name: "#{query} two" }
    let(:trusts) { [trust, trust_two] }
    let(:user) { create :user }
    let(:redis) { Redis.new }
    let(:redis_key) { "test_block_cache_trusts_#{query}" }

    before do
      redis.del(redis_key)
      sign_in user
      mock_trust_search(query, trusts)
      get trusts_url, params: { "input-autocomplete" => query }, as: :json
    end

    it "returns the trust names" do
      expect(response.body).to eq([trust.trust_name, trust_two.trust_name].to_json)
    end
  end
end
