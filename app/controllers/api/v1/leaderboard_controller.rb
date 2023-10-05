class Api::V1::LeaderboardController < ApplicationController
  respond_to :json

  def index
    if params[:country].present? && params[:country].is_a?(String)
      @users =
        User.where(country: params[:country].upcase)
            .order(score: :desc)
            .limit(100)
    else
      @users = Leader.all
    end

    render json: @users
  end

  private

  def permitted_params
    params.permit(:country)
  end
end
