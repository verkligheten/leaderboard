class UpdateUsersScoreJob < ApplicationJob
  queue_as :default

  def perform(user_ids)
    user_ids.each do |user_id|
      user = User.find_by(id: user_id)

      next unless user

      possible_score = (user.score.presence || 150) + rand(-10_000..10_000)
      new_score = if possible_score <= 150
        150
      elsif possible_score >= 1_000_000
        1_000_000
      else
        possible_score
      end

      user.update score: new_score
    end
  end
end
