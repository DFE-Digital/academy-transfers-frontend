require "rails_helper"

RSpec.describe "/trusts", type: :request do
  let(:trust) { build :trust }
  let(:query) { trust.trust_name }
  let(:trusts) { [trust] }
  let(:user) { create :user }

  before do
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
    let(:trusts) { build_list :trust, 2, trust_name: query }
    let(:trust) { trusts.first }

    before do
      mock_trust_search(query, trusts)
      get search_trusts_url, params: { "input-autocomplete" => query }, as: :json
    end

    it "returns the trust names" do
      expect(response.body).to eq([query, query].to_json)
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
