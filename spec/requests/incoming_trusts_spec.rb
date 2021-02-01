require "rails_helper"

RSpec.describe "IncomingTrusts", type: :request do
  let(:trust) { build :trust }
  let(:outgoing_trust) { trust }
  let(:incoming_trust) { build :trust }
  let(:user) { create :user }
  let(:session_store) { SessionStore.new(user, trust.id) }

  before { sign_in user }

  describe "GET /outgoing_trust/:outgoing_trust_id/incoming" do
    subject { get outgoing_trust_incoming_trusts_path(trust.id) }

    it "returns http success" do
      subject
      expect(response).to have_http_status(:success)
    end

    context "when incoming trust already added" do
      before do
        session_store.set :incoming_trust_ids, [incoming_trust.id]
        ModelCache.set(incoming_trust)
        subject
      end

      it "displays trust" do
        expect(response.body).to include(incoming_trust.trust_name)
      end
    end
  end

  describe "GET /outgoing_trusts/:outgoing_trust_id/incoming/search" do
    let(:query) { incoming_trust.trust_name }
    let(:trusts) { [incoming_trust] }
    let(:redis) { Redis.new }
    let(:redis_key) { "test_block_cache_trusts_#{query}" }
    let(:submit_button) { :search_button }
    let(:previously_saved) { [] }
    let(:params) do
      {
        "input-autocomplete" => query,
        "commit" => I18n.t("incoming_trusts.index.#{submit_button}"),
      }
    end

    before do
      redis.del(redis_key)
      mock_trust_search(query, trusts)
      session_store.set :incoming_trust_ids, previously_saved
      get search_outgoing_trust_incoming_trusts_url(outgoing_trust.id), params: params
    end

    it "Redirects to new projects for single result" do
      expect(response).to redirect_to(new_outgoing_trust_project_path(outgoing_trust.id))
    end

    context "when multiple results" do
      let(:query) { Faker::Educator.secondary_school }
      let(:trusts) { build_list :trust, 2, trust_name: query }
      let(:incoming_trust) { trusts.first }
      let(:link_back_to_search) do
        search_outgoing_trust_incoming_trusts_path(
          outgoing_trust.id,
          "input-autocomplete" => incoming_trust.trust_name,
          commit: I18n.t("incoming_trusts.index.add_trust"),
        )
      end

      it "Renders successfully" do
        expect(response).to be_successful
      end

      it "displays link back to search with trust name as input" do
        expect(response.body).to include(incoming_trust.trust_name)
        expect(response.body).to include(CGI.escapeHTML(link_back_to_search))
      end

      it "renders search template" do
        expect(response.body).to include(I18n.t("incoming_trusts.search.heading"))
      end
    end

    context "when Add button submitted" do
      let(:submit_button) { :add_trust }

      it "Renders successfully" do
        expect(response).to be_successful
      end

      it "stores incoming trust in session store" do
        expect(session_store.get(:incoming_trust_ids)).to eq([incoming_trust.id])
      end

      it "renders index template" do
        expect(response.body).to include(I18n.t("incoming_trusts.index.heading"))
      end
    end

    context "when nothing entered" do
      let(:query) { "" }

      it "Renders successfully" do
        expect(response).to be_successful
      end

      it "displays error" do
        expect(response.body).to include(I18n.t("errors.trust.empty_search_error"))
      end

      it "renders index template" do
        expect(response.body).to include(I18n.t("incoming_trusts.index.heading"))
      end
    end

    context "when nothing entered, and incoming trusts already added" do
      let(:query) { "" }
      let(:trusts) { [] }
      let(:previously_saved) { [incoming_trust.id] }

      it "Redirects to new project for single result" do
        expect(response).to redirect_to(new_outgoing_trust_project_path(outgoing_trust.id))
      end
    end
  end

  describe "DELETE /outgoing_trusts/:outgoing_trust_id/incoming/:id" do
    subject { delete outgoing_trust_incoming_trust_path(outgoing_trust.id, incoming_trust.id) }

    it "Redirects to the search page" do
      subject
      expect(response).to redirect_to(outgoing_trust_incoming_trusts_path(outgoing_trust.id))
    end

    context "incoming trust is present in session store" do
      before do
        session_store.set :incoming_trust_ids, [incoming_trust.id]
      end

      it "Removed the incoming trust id from session store" do
        subject
        expect(session_store.get(:incoming_trust_ids)).not_to include(incoming_trust.id)
      end

      it "Redirects to the search page" do
        subject
        expect(response).to redirect_to(outgoing_trust_incoming_trusts_path(outgoing_trust.id))
      end
    end
  end
end
