class PopulateLeadersJob < ApplicationJob
  queue_as :leaders

  def perform(*args)
    PopulateLeaders.new.call
  end
end
