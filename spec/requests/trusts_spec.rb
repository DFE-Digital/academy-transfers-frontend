require "rails_helper"

RSpec.describe "/trusts", type: :request do
  let(:trust) { build :trust }
  let(:query) { trust.trust_name }
  let(:trusts) { [trust] }
  let(:user) { create :user }
  let(:redis) { Redis.new }
  let(:redis_key) { "test_block_cache_trusts_#{query}" }

  before do
    redis.del(redis_key)
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get trusts_url
      expect(response).to be_successful
    end
  end

  describe "GET /search" do
    before do
      mock_trust_search(query, trusts)
      get search_trusts_url, params: { "input-autocomplete" => query }
    end

    it "Redirects to show for single result" do
      expect(response).to redirect_to(trust_path(trust.id))
    end

    context "when multiple results" do
      let(:query) { Faker::Educator.secondary_school }
      let(:trusts) { build_list :trust, 2, trust_name: query }
      let(:trust) { trusts.first }

      it "renders a successful response" do
        expect(response).to be_successful
      end

      it "displays link to trust's show page" do
        expect(response.body).to include(trust.trust_name)
        expect(response.body).to include(trust_path(trust.id))
      end
    end
  end

  describe "GET /search.json" do
    let(:query) { Faker::Educator.secondary_school }
    let(:trust) { build :trust, trust_name: "#{query} one" }
    let(:trust_two) { build :trust, trust_name: "#{query} two" }
    let(:trusts) { [trust, trust_two] }

    before do
      mock_trust_search(query, trusts)
      get search_trusts_url, params: { "input-autocomplete" => query }, as: :json
    end

    it "returns the trust names" do
      expect(response.body).to eq([trust.trust_name, trust_two.trust_name].to_json)
    end
  end

  describe "GET /show/:id" do
    before do
      mock_trust_find(trust)
    end

    it "renders a successful response" do
      get trust_url(trust.id)
      expect(response).to be_successful
    end
  end
end
