class ProjectsController < ApplicationController
  before_action :authenticate_user!

  # GET /trusts/:trust_id/projects/new
  def new
    @outgoing_trust = Trust.find(outgoing_trust_id)
    @academies = Academy.belonging_to_trust(@outgoing_trust.id).select { |academy| selected_academy_ids.include?(academy.id) }
    incoming_trusts
  end

  # POST /trusts/:trust_id/projects
  def create
    @project = Project.new(project_params)

    api_response = @project.save
    render json: {
      "API Response" => api_response,
      "Submitted data" => @project.api_payload,
    }
  end

  # GET /projects
  def index
    @projects = Project.search(params)
  end

  # GET/projects/:id
  def show; end

private

  def project_params
    {
      project_initiator_uid: current_user.uid,
      project_initiator_full_name: current_user.username,
      project_status: Project::STATUS[:in_progress],
      academy_ids: session_store.get(:academy_ids),
      outgoing_trust_id: outgoing_trust_id,
      incoming_trust_id: session_store.get(:incoming_trust_ids).first,
    }
  end

  def session_store
    @session_store ||= SessionStore.new(current_user, outgoing_trust_id)
  end

  def outgoing_trust_id
    @outgoing_trust_id = params[:outgoing_trust_id]
  end

  def selected_academy_ids
    session_store.get(:academy_ids)
  end

  def incoming_trusts
    @incoming_trusts ||= incoming_trust_ids.map { |trust_id| Trust.find(trust_id) }
  end

  def incoming_trust_ids
    @incoming_trust_ids ||= session_store.get(:incoming_trust_ids) || []
  end
end
