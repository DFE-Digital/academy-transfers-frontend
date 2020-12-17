require 'rails_helper'

RSpec.describe Trust, type: :model do
  let(:trust) { build :trust }
  let(:access_token) { SecureRandom.uuid }

  describe ".search" do
    before do
      mock_trust_search("something", [trust])
    end

    it "returns matching trust" do
      results = described_class.search("something")
      
      expect(results.length).to eq(1)
      expect(results.first.as_json).to eq(trust.as_json)
    end
  end
end
