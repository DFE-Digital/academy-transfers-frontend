class AcademiesController < ApplicationController
  before_action :authenticate_user!

  # GET /academies
  def index
    academies
    academy_ids
  end

  # POST /academies
  def create
    if academy_data.present?
      session_store.set :academy_ids, academy_data
      redirect_to outgoing_trust_identify_path(outgoing_trust_id)
    else
      @error = I18n.t("errors.trust.no_academy_selected")
      academies
      academy_ids
      render :index
    end
  end

private

  def session_store
    @session_store ||= SessionStore.new(current_user, outgoing_trust_id)
  end

  def academies
    @academies ||= Academy.belonging_to_trust(outgoing_trust_id)
  end

  def academy_data
    @academy_data ||= params.dig(:trust, :academy_ids).select(&:present?)
  end

  def academy_ids
    @academy_ids ||= session_store.get(:academy_ids) || []
  end

  def outgoing_trust_id
    params[:outgoing_trust_id]
  end
end
