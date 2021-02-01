class DashboardController < ApplicationController
  before_action :authenticate_user!

  breadcrumb :dashboard, :root_path

  def index
    @in_progress_projects = Project.in_progress(ascending: false, page_size: 5)
    @completed_projects = Project.completed(ascending: false, page_size: 5)
  end
end
