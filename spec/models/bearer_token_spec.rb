require 'rails_helper'

RSpec.describe BearerToken do
  let(:access_token) { SecureRandom.uuid }

  describe ".token" do
    before do
      mock_bearer_token_retrieval(access_token)
    end

    it "returns the access token returned from the oauth login" do
      expect(described_class.token).to eq(access_token)
    end
  end
end
