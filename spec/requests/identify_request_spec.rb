require "rails_helper"

RSpec.describe "Identify", type: :request do
  let(:trust) { build :trust }
  let(:user) { create :user }
  let(:session_store) { SessionStore.new(user, trust.id) }

  before { sign_in user }

  describe "GET /outgoing_trust/:outgoing_trust_id/identify" do
    it "returns http success" do
      get outgoing_trust_identify_path(trust.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /outgoing_trust/:outgoing_trust_id/identify" do
    let(:trust_identified) { "yes" }
    let(:params) do
      { trust_identified: trust_identified }
    end
    subject { post outgoing_trust_identify_path(trust.id), params: params }

    it "redirects to incoming trusts" do
      subject
      expect(response).to redirect_to(outgoing_trust_incoming_trusts_path(trust.id))
    end

    it "records choice in session_store" do
      subject
      expect(session_store.get(:incoming_trust_identified)).to eq(trust_identified)
    end

    context "when no trust identified" do
      let(:trust_identified) { "no" }

      it "redirects to identified" do
        subject
        expect(response).to redirect_to(outgoing_trust_incoming_trusts_path(trust.id))
      end

      it "records choice in session_store" do
        subject
        expect(session_store.get(:incoming_trust_identified)).to eq(trust_identified)
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
end
