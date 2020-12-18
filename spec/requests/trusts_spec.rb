require 'rails_helper'

RSpec.describe "/trusts", type: :request do
  let(:trust) { build :trust }
  let(:query) { trust.trust_name }

  describe "GET /index" do
    it "renders a successful response" do
      get trusts_url
      expect(response).to be_successful
    end
  end

  describe "GET /search" do
    before do
      mock_trust_search(query, [trust])
      get search_trusts_url, params: { query: query }
    end

    it "renders a successful response" do
      expect(response).to be_successful
    end

    it "displays link to trust's show page" do
      expect(response.body).to include(trust.trust_name)
      expect(response.body).to include(trust_path(trust.id))
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
