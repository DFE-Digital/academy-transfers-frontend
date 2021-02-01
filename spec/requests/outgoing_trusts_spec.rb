require "rails_helper"

RSpec.describe "/outgoing_trusts", type: :request do
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

  describe "GET /new" do
    it "renders a successful response" do
      get new_outgoing_trust_url
      expect(response).to be_successful
    end
  end

  describe "POST /" do
    before do
      mock_trust_search(query, trusts)
      post outgoing_trusts_url, params: { "input-autocomplete" => query }
    end

    it "Redirects to show for single result" do
      expect(response).to redirect_to(outgoing_trust_path(trust.id))
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
        expect(response.body).to include(outgoing_trust_path(trust.id))
      end
    end
  end

  describe "GET /show/:id" do
    before do
      mock_trust_find(trust)
    end

    it "renders a successful response" do
      get outgoing_trust_url(trust.id)
      expect(response).to be_successful
    end
  end
end
