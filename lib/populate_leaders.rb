class PopulateLeaders

  def call
    max_scores = User.select("country, MAX(score) as max_score").group("country")
    users =
      User.joins("INNER JOIN (#{max_scores.to_sql}) max_scores \
                  ON users.country = max_scores.country \
                  AND users.score = max_scores.max_score")
          .select("users.id, users.name, users.country, users.score")
          .map do |user|
      { user_id: user.id, name: user.name, country: user.country, score: user.score }
    end

    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE leaders;")

      Leader.insert_all users
    end
  end
end
