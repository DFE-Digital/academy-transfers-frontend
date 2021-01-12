require "rails_helper"

RSpec.describe "IncomingTrusts", type: :request do
  let(:trust) { build :trust }
  let(:user) { create :user }

  before { sign_in user }

  describe "GET /trust/:trust_id/incoming" do
    it "returns http success" do
      get trust_incoming_trusts_path(trust.id)
      expect(response).to have_http_status(:success)
    end
  end
end
