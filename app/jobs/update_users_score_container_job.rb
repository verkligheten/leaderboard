class UpdateUsersScoreContainerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ids = User.pluck(:id).sample(6_000)

    ids.in_groups_of(100, false) do |ids_batch|
      UpdateUsersScoreJob.perform_later(ids_batch)
      sleep 1
    end
  end
end
