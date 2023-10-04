class PopulateLeaderboardJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rake::Task['seed:leaderboard'].execute
  end
end