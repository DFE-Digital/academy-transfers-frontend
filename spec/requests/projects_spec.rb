require "rails_helper"

RSpec.describe "/projects", type: :request do
  let(:user) { create :user }
  let(:academy) { build :academy }
  let(:incoming_trust) { build :trust }
  let(:outgoing_trust) { build :trust }
  let(:project_status) { Project::STATUS[:in_progress] }
  let(:project) do
    Project.new(
      project_initiator_uid: user.uid,
      project_initiator_full_name: user.username,
      project_status: project_status,
      academy_ids: [academy.id],
      outgoing_trust_id: outgoing_trust.id,
      incoming_trust_id: incoming_trust.id,
    )
  end
  let(:session_store) { SessionStore.new(user, outgoing_trust.id) }

  before { sign_in user }

  describe "POST /trusts/:trust_id/projects" do
    let(:response_body) { { foo: :bar }.to_json }

    before do
      session_store.set(:academy_ids, [academy.id])
      session_store.set(:incoming_trust_ids, [incoming_trust.id])
      mock_project_save(project, response_body)
    end
    subject { post outgoing_trust_projects_path(outgoing_trust.id) }

    it "renders successfully" do
      subject
      expect(response.status).to eq(200)
    end
  end

  describe "GET /trusts/:trust_id/projects/new" do
    let(:academy) { build :academy }

    before do
      mock_academies_belonging_to_trust(outgoing_trust, [academy])
      mock_trust_find(incoming_trust)
      mock_trust_find(outgoing_trust)
      session_store.set :academy_ids, [academy.id]
      session_store.set :incoming_trust_ids, [incoming_trust.id]
      get new_outgoing_trust_project_path(outgoing_trust.id, incoming_trust.id)
    end

    it "renders a successful response" do
      expect(response).to be_successful
    end

    it "displays outgoing trust information" do
      expect(response.body).to include(outgoing_trust.trust_reference_number)
    end

    it "displays incoming trust information" do
      expect(response.body).to include(incoming_trust.trust_reference_number)
    end

    it "displays academy information" do
      expect(response.body).to include(academy.urn)
    end
  end
end
