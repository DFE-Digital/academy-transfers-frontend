class TrustsController < ApplicationController
  # GET /trusts
  def index; end

  # GET /trusts/search
  def search
    @trusts = Trust.search(params[:query])
  end

  # GET /trusts/1
  def show
    @trust = Trust.find(params[:id])
  end
end
