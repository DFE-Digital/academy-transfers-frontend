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

  def identified
    incoming_trusts
  end

  def search
    @trusts = search_result

    return render :search unless @trusts.one? || empty_search?

    if @trusts.present?
      incoming_trust_ids << @trusts.first.id unless incoming_trust_ids.include?(@trusts.first.id)
      session_store.set :incoming_trust_ids, incoming_trust_ids
    end

    if search_error || add_trust_selected?
      incoming_trusts
      render :identified
    else
      redirect_to trust_incoming_trust_path(outgoing_trust_id, incoming_trust_ids.first)
    end
  end

  def show
    @outgoing_trust = Trust.find(outgoing_trust_id)
    @academies = Academy.belonging_to_trust(@outgoing_trust.id).select { |academy| selected_academy_ids.include?(academy.id) }
    incoming_trusts
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

  def incoming_trusts
    @incoming_trusts ||= incoming_trust_ids.map { |trust_id| Trust.find(trust_id) }
  end

  def incoming_trust_ids
    @incoming_trust_ids ||= session_store.get(:incoming_trust_ids) || []
  end

  def identified_scope
    "incoming_trusts.identified"
  end

  def add_trust_selected?
    params[:commit] == I18n.t(:add_trust, scope: identified_scope)
  end

  def empty_search?
    search_input.blank?
  end

  def search_error
    @search_error = I18n.t("errors.trust.empty_search_error") if search_input.empty? && incoming_trust_ids.empty?
  end

  def search_input
    params["input-autocomplete"]
  end

  def search_result
    return [] if empty_search?

    Trust.search(search_input)
  end
end
