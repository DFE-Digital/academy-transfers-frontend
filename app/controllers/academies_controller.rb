class AcademiesController < ApplicationController
  before_action :authenticate_user!

  # GET /academies
  def index
    academies
  end

  # POST /academies
  def create
    if academy_data.present?
      session_store.set :academy_ids, academy_data
      redirect_to trust_incoming_trusts_path(params[:trust_id])
    else
      @error = I18n.t("errors.trust.no_academy_selected")
      academies
      render :index
    end
  end

private

  def session_store
    @session_store ||= SessionStore.new(current_user, params[:trust_id])
  end

  def academies
    @academies ||= Academy.belonging_to_trust(params[:trust_id])
  end

  def academy_data
    @academy_data ||= params.dig(:trust, :academy_ids).select(&:present?)
  end
end
