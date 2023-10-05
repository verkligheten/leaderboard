require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app

  # Defines the root path route ("/")
  root to: "home#index"

  namespace :api do
    namespace :v1 do
      get :leaderboard, controller: :leaderboard, action: :index
    end
  end
end
