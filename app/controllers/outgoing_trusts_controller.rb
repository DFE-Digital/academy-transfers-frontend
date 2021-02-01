class OutgoingTrustsController < ApplicationController
  before_action :authenticate_user!

  breadcrumb :dashboard, :root_path
  breadcrumb :add_new_project, :trusts_path

  # GET /trusts/new
  def new; end

  # POST /trusts
  def create
    @trusts = Trust.search(params["input-autocomplete"])
    redirect_to outgoing_trust_path(@trusts.first.id) if @trusts.one?
  end

  # GET /trusts/1
  def show
    @trust = Trust.find(params[:id])
    breadcrumb :trust_details, outgoing_trust_path(@trust.id)
  end
end
