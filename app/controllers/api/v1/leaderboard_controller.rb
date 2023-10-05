class Api::V1::LeaderboardController < ApplicationController
  respond_to :json

  def index
    if params[:country].present? && params[:country].is_a?(String)
      @users =
        User.where(country: params[:country].upcase)
            .order(score: :desc)
            .limit(100)
    else
      subquery =
        User.select("country, MAX(score) as max_score")
            .group("country")
            .to_sql
      # Create a query to join the subquery and retrieve the users with the highest scores
      query =
        User.joins("INNER JOIN (#{subquery}) max_scores \
                    ON users.country = max_scores.country \
                    AND users.score = max_scores.max_score")
            .select("users.id, users.name, users.country, users.score")
            .order("users.score desc")
      @users = User.find_by_sql(query.to_sql)
    end

    render json: @users
  end

  private

  def permitted_params
    params.permit(:country)
  end
end
