class User < ApplicationRecord

  scope :by_score_range, ->(gte, lte) {
    where(
      arel_table[:score].gt(gte)
        .and(arel_table[:score].lt(lte))
      )
  }

  def self.ransackable_attributes(auth_object = nil)
    ["country", "created_at", "id", "name", "score", "updated_at"]
  end
end
