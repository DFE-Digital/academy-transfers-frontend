require "rails_helper"

RSpec.describe Academy, type: :model do
  let(:trust) { build :trust }
  let(:academies) { build_list :academy, 2, parent_trust_id: trust.id }

  describe ".belonging_to_trust" do
    let(:results) { described_class.belonging_to_trust(trust.id) }

    before do
      mock_academies_belonging_to_trust(trust, academies)
    end

    it "returns matching academies" do
      expect(results.map(&:as_json)).to match_array(academies.map(&:as_json))
    end
  end
end
