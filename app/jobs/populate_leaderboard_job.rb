class PopulateLeaderboardJob < ApplicationJob
  queue_as :leaders

  def perform(*args)
    PopulateLeaderboard.new.call
  end
end
