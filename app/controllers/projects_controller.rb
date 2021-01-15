class ProjectsController < ApplicationController
  # POST /trusts/:trust_id/projects
  def create
    @project = Project.new(project_params)

    api_response = @project.save
    render json: {
      "API Response" => api_response,
      "Submitted data" => @project.api_payload,
    }
  end

private

  def project_params
    {
      project_initiator_uid: current_user.uid,
      project_initiator_full_name: current_user.username,
      project_status: Project::STATUS[:in_progress],
      academy_ids: session_store.get(:academy_ids),
      outgoing_trust_id: params[:trust_id],
      incoming_trust_id: session_store.get(:incoming_trusts).first,
    }
  end

  def session_store
    @session_store ||= SessionStore.new(current_user, params[:trust_id])
  end
end
