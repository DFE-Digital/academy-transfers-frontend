class IncomingTrustsController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def create
    if trust_identified
      session_store.set :incoming_trust_identified, trust_identified
      redirect_to identified_trust_incoming_trusts_path(outgoing_trust_id)
    else
      @error = I18n.t("errors.must_select_yes_or_no")
      render :index
    end
  end

  def identified; end

  def search
    @trusts = Trust.search(params["input-autocomplete"])

    redirect_to trust_incoming_trust_path(outgoing_trust_id, @trusts.first.id) if @trusts.one?
  end

  def show
    session_store.set :incoming_trusts, [params[:id]]
    @outgoing_trust = Trust.find(outgoing_trust_id)
    @academies = Academy.belonging_to_trust(@outgoing_trust.id).select { |academy| selected_academy_ids.include?(academy.id) }
    @incoming_trust = Trust.find(params[:id])
  end

private

  def session_store
    @session_store ||= SessionStore.new(current_user, params[:trust_id])
  end

  def selected_academy_ids
    session_store.get(:academy_ids)
  end

  def outgoing_trust_id
    @outgoing_trust_id = params[:trust_id]
  end

  def trust_identified
    params[:trust_identified]
  end
end
