class UpdateUsersScoreContainerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ids = User.order("RANDOM()").limit(6_000).pluck(:id)

    ids.in_groups_of(100, false) do |ids_batch|
      UpdateUsersScoreJob.perform_later(ids_batch)
      sleep 1
    end
  end
end
