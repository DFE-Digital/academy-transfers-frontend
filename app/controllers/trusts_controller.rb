class TrustsController < ApplicationController
  before_action :authenticate_user!

  # GET /trusts
  def index; end

  # GET /trusts/search
  def search
    @trusts = Trust.search(params["input-autocomplete"])

    respond_to do |format|
      format.html do
        redirect_to trust_path(@trusts.first.id) if @trusts.one?
      end
      format.json { render json: @trusts.map(&:trust_name) }
    end
  end

  # GET /trusts/1
  def show
    @trust = Trust.find(params[:id])
  end
end
