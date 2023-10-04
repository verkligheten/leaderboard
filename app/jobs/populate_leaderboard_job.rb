class PopulateLeaderboardJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PopulateLeaderboard.new.call
  end
end
