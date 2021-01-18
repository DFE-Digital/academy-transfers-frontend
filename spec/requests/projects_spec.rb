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

  describe "POST /trusts/:trust_id/projects" do
    let(:response_body) { { foo: :bar }.to_json }

    before do
      sign_in user
      session_store.set(:academy_ids, [academy.id])
      session_store.set(:incoming_trusts, [incoming_trust.id])
      mock_project_save(project, response_body)
    end
    subject { post trust_projects_path(outgoing_trust.id) }

    it "renders successfully" do
      subject
      expect(response.status).to eq(200)
    end
  end
end
