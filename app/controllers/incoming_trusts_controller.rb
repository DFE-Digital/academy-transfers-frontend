class IncomingTrustsController < ApplicationController
  before_action :authenticate_user!

  def index
    incoming_trusts
  end

  def create
    @trusts = search_result

    return render :create unless @trusts.one? || empty_search?

    if @trusts.present?
      incoming_trust_ids << @trusts.first.id unless incoming_trust_ids.include?(@trusts.first.id)
      session_store.set :incoming_trust_ids, incoming_trust_ids
    end

    if search_error || add_trust_selected?
      incoming_trusts
      render :index
    else
      redirect_to new_outgoing_trust_project_path(outgoing_trust_id)
    end
  end

  def destroy
    if incoming_trust_ids.delete(params[:id])
      session_store.set :incoming_trust_ids, incoming_trust_ids
    end
    redirect_to(outgoing_trust_incoming_trusts_path(outgoing_trust_id))
  end

private

  def session_store
    @session_store ||= SessionStore.new(current_user, params[:outgoing_trust_id])
  end

  def outgoing_trust_id
    @outgoing_trust_id = params[:outgoing_trust_id]
  end

  def trust_identified
    params[:trust_identified]
  end

  def incoming_trusts
    @incoming_trusts ||= incoming_trust_ids.map { |trust_id| Trust.find(trust_id) }
  end

  def incoming_trust_ids
    @incoming_trust_ids ||= session_store.get(:incoming_trust_ids) || []
  end

  def index_scope
    "incoming_trusts.index"
  end

  def add_trust_selected?
    params[:commit] == I18n.t(:add_trust, scope: index_scope)
  end

  def empty_search?
    search_input.blank?
  end

  def search_error
    @search_error = I18n.t("errors.trust.empty_search_error") if search_input.blank? && incoming_trust_ids.empty?
  end

  def search_input
    params["input-autocomplete"]
  end

  def search_result
    return [] if empty_search?

    Trust.search(search_input)
  end
end
