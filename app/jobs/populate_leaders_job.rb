class PopulateLeadersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    2.times do
      PopulateLeaders.new.call
      sleep 15
    end
  end
end
