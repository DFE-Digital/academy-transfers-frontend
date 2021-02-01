require "rails_helper"
RSpec.describe "Academies", type: :request do
  let(:trust) { build :trust }
  let(:academies) { build_list :academy, 2, parent_trust_id: trust.id }
  let(:academy_ids) { academies.map(&:id) }
  let(:academy) { academies.first }
  let(:other_academy) { academies.last }
  let(:user) { create :user }
  let(:session_store) { SessionStore.new(user, trust.id) }

  before { sign_in user }

  describe "GET /outgoing_trust/:outgoing_trust_id/academies" do
    before do
      mock_academies_belonging_to_trust(trust, academies)
    end

    it "renders a successful response" do
      get outgoing_trust_academies_path(trust.id)
      expect(response).to be_successful
    end
  end

  describe "POST /outgoing_trust/:outgoing_trust_id/academies" do
    let(:params) do
      {
        trust: {
          academy_ids: [academy.id],
        },
      }
    end

    subject do
      post outgoing_trust_academies_path(trust.id), params: params
    end

    it "stores the academy ids in session store" do
      expect { subject }.to change { session_store.get(:academy_ids) }.to([academy.id])
    end

    it "redirects to next page" do
      subject
      expect(response).to redirect_to(outgoing_trust_identify_path(trust.id))
    end

    context "with noting selected" do
      let(:params) do
        {
          trust: {
            academy_ids: [""],
          },
        }
      end

      before do
        mock_academies_belonging_to_trust(trust, academies)
      end

      it "does not change session store" do
        expect { subject }.not_to change { session_store.get(:academy_ids) }
      end

      it "renders successfully" do
        subject
        expect(response).to be_successful
      end

      it "displays and error" do
        subject
        expect(response.body).to include("govuk-error-summary")
      end
    end
  end
end
