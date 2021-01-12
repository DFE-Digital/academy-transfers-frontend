require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  let(:user) { create :user }

  before { sign_in user }

  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
