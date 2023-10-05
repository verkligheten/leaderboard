class PopulateLeadersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PopulateLeaders.new.call
  end
end
