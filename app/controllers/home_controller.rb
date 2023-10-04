class HomeController < ApplicationController
  def index
    @users =
      User.select(:id, :name, :country, :score)
          .order(score: :desc)
          .limit(100)
  end
end
