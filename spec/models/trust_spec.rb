require "rails_helper"

RSpec.describe Trust, type: :model do
  let(:trust) { build :trust }

  describe ".search" do
    let(:results) { described_class.search("something") }

    before do
      mock_trust_search("something", [trust])
    end

    it "returns matching trust" do
      expect(results.length).to eq(1)
      expect(results.first.as_json).to eq(trust.as_json)
    end
  end

  describe ".find" do
    let(:result) { described_class.find(trust.id) }

    before do
      mock_trust_find(trust)
    end

    it "returns the trust" do
      expect(result.as_json).to eq(trust.as_json)
    end
  end
end
