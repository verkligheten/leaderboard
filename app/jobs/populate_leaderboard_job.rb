

class PopulateLeaderboardJob < ApplicationJob
  require 'rake'

  queue_as :default

  def perform(*args)
    Rails.application.load_tasks
    Rake::Task['seed:leaderboard'].execute
  end
end
