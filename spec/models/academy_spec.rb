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

  describe "#ofsted_inspection_date_formatted" do
    let(:academy) { build :academy }

    it "is in govuk format" do
      date = Date.parse(academy.ofsted_inspection_date)
      expect(academy.ofsted_inspection_date_formatted).to eq(date.to_s(:govuk))
    end
  end

  describe "#academy_name_with_urn" do
    let(:urn) { "123456" }
    let(:academy) { build :academy, academy_name: "Foo", urn: urn }

    it "display both name and urn" do
      expect(academy.academy_name_with_urn).to eq("Foo (URN 123456)")
    end

    context "without urn" do
      let(:urn) { nil }

      it "displays the name" do
        expect(academy.academy_name_with_urn).to eq("Foo")
      end
    end
  end
end
