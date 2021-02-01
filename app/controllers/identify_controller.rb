class IdentifyController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    if trust_identified
      session_store.set :incoming_trust_identified, trust_identified
      redirect_to trust_incoming_trusts_path(outgoing_trust_id)
    else
      @error = I18n.t("errors.must_select_yes_or_no")
      render :show
    end
  end

private

  def session_store
    @session_store ||= SessionStore.new(current_user, params[:trust_id])
  end

  def trust_identified
    params[:trust_identified]
  end

  def outgoing_trust_id
    @outgoing_trust_id = params[:trust_id]
  end
end
