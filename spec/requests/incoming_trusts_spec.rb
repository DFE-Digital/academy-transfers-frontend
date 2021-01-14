require "rails_helper"

RSpec.describe "IncomingTrusts", type: :request do
  let(:trust) { build :trust }
  let(:outgoing_trust) { trust }
  let(:incoming_trust) { build :trust }
  let(:user) { create :user }

  before { sign_in user }

  describe "GET /trust/:trust_id/incoming" do
    it "returns http success" do
      get trust_incoming_trusts_path(trust.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /trust/:trust_id/incoming" do
    let(:trust_identified) { "yes" }
    let(:params) do
      { trust_identified: trust_identified }
    end
    subject { post trust_incoming_trusts_path(trust.id), params: params }

    it "redirects to identified" do
      subject
      expect(response).to redirect_to(identified_trust_incoming_trusts_path(trust.id))
    end

    context "when no trust identified" do
      let(:trust_identified) { "no" }

      xit "redirects to ..." do
        subject
        expect(response).to redirect_to(:tbc)
      end
    end

    context "when nothing selected" do
      let(:trust_identified) { nil }

      it "successfully renders page" do
        subject
        expect(response).to have_http_status(:success)
      end

      it "displays error" do
        subject
        expect(response.body).to include(I18n.t("errors.must_select_yes_or_no"))
      end
    end
  end

  describe "GET /trust/:trust_id/incoming/identified" do
    it "returns http success" do
      get identified_trust_incoming_trusts_path(trust.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /trusts/:trust_id/incoming/search" do
    let(:query) { incoming_trust.trust_name }
    let(:trusts) { [incoming_trust] }
    let(:redis) { Redis.new }
    let(:redis_key) { "test_block_cache_trusts_#{query}" }

    before do
      redis.del(redis_key)
      mock_trust_search(query, trusts)
      get search_trust_incoming_trusts_url(outgoing_trust.id), params: { "input-autocomplete" => query }
    end

    it "Redirects to show for single result" do
      expect(response).to redirect_to(trust_incoming_trust_path(outgoing_trust.id, incoming_trust.id))
    end

    context "when multiple results" do
      let(:query) { Faker::Educator.secondary_school }
      let(:trusts) { build_list :trust, 2, trust_name: query }
      let(:incoming_trust) { trusts.first }

      it "renders a successful response" do
        expect(response).to be_successful
      end

      it "displays link to incoming trust's show page" do
        expect(response.body).to include(incoming_trust.trust_name)
        expect(response.body).to include(trust_incoming_trust_path(outgoing_trust.id, incoming_trust.id))
      end
    end
  end

  describe "GET /trusts/:trust_id/incoming/:id" do
    let(:session_store) { SessionStore.new(user, trust.id) }
    let(:academy) { build :academy }

    before do
      mock_academies_belonging_to_trust(outgoing_trust, [academy])
      mock_trust_find(incoming_trust)
      mock_trust_find(outgoing_trust)
      session_store.set :academy_ids, [academy.id]
      get trust_incoming_trust_path(outgoing_trust.id, incoming_trust.id)
    end

    it "renders a successful response" do
      expect(response).to be_successful
    end

    it "displays outgoing trust information" do
      expect(response.body).to include(outgoing_trust.trust_reference_number)
    end

    it "displays incoming trust information" do
      expect(response.body).to include(incoming_trust.trust_reference_number)
    end

    it "displays academy information" do
      expect(response.body).to include(academy.urn)
    end
  end
end
