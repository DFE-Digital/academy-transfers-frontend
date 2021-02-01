class TrustsController < ApplicationController
  before_action :authenticate_user!

  def index
    @trusts = Trust.search(params["input-autocomplete"])
    render json: @trusts.map(&:trust_name)
  end
end
