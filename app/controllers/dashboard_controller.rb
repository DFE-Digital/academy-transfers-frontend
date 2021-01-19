class DashboardController < ApplicationController
  before_action :authenticate_user!

  breadcrumb :dashboard, :root_path

  def index; end
end
