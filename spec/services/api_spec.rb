require "rails_helper"

RSpec.describe Api do
  let(:root_url) { Faker::Internet.url(host: "example.com") }
  let(:query) { nil }
  let(:url) do
    uri = URI(root_url)
    uri.query = query.to_query if query
    uri.to_s
  end

  let(:body) { { foo: :bar }.to_json }
  let(:access_token) { SecureRandom.uuid }
  let(:stub_get) do
    stub_request(:get, url)
      .with(headers: { "Authorization" => "Bearer #{access_token}" })
      .to_return(body: body)
  end
  let(:stub_post) do
    stub_request(:post, root_url)
      .with(
        headers: { "Authorization" => "Bearer #{access_token}" },
        body: query.to_json,
      )
      .to_return(body: body)
  end
  let(:stub_call_to_api) { stub_get }

  let(:api) { described_class.new(root_url, query) }

  before do
    mock_bearer_token_retrieval(access_token)
    stub_call_to_api
  end

  describe ".get" do
    subject { described_class.get(root_url, query) }

    it "returns body" do
      expect(subject.body).to eq(body)
    end

    context "with query" do
      let(:query) { { find: :me } }

      it "returns body" do
        expect(subject.body).to eq(body)
      end
    end
  end

  describe "#get" do
    subject { api.get }

    it "returns body" do
      expect(subject.body).to eq(body)
    end

    context "with query" do
      let(:query) { { find: :me } }

      it "returns body" do
        expect(subject.body).to eq(body)
      end
    end
  end

  describe ".post" do
    let(:method) { :post }
    let(:query) { { some: :data } }
    let(:stub_call_to_api) { stub_post }

    subject { described_class.post(root_url, query) }

    it "returns body" do
      expect(subject.body).to eq(body)
    end
  end

  describe "#post" do
    let(:method) { :post }
    let(:query) { { some: :data } }
    let(:stub_call_to_api) { stub_post }

    subject { api.post }

    it "returns body" do
      expect(subject.body).to eq(body)
    end
  end
end
