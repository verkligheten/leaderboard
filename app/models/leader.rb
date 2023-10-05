class Leader < ApplicationRecord
  def as_json(*args)
    super.tap { |hash| hash["id"] = hash.delete "user_id" }
  end
end
