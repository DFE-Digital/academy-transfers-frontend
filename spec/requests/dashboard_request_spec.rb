require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  let(:in_progress_projects) { build_list :project, 6, project_status: 1 }
  let(:completed_projects) { build_list :project, 6, project_status: 2 }
  let(:user) { create :user }

  before { sign_in user }

  describe "GET /" do
    before do
      mock_project_search(in_progress_projects, status: 1, ascending: false, page_size: 5)
      mock_project_search(completed_projects, status: 2, ascending: false, page_size: 5)
    end

    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "displays in progress projects" do
      get root_path
      expect(response.body).to include(in_progress_projects.first.project_name)
    end

    it "displays in completed projects" do
      get root_path
      expect(response.body).to include(completed_projects.first.project_name)
    end
  end
end
