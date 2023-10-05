# README

1. Data Seed.
```ruby
# This will generate 1M records.
PopulateLeaderboard.new.call

# To generate more data it's recommended to run it with delayed jobs

150.times { PopulateLeaderboardJob.perform_later }
```

2. User should have score from 150..1_000_000
```ruby
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
```

3. Every second some amount of users should get a new score. User could get or loose X scores.
```ruby
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
```

4. Leader board contains 100 worldwide leaders
https://www.grabli.co

5. User's structure
```ruby
name: String
country: String
score: Integer
created_at: DateTime
updated_at: DateTime
```

6. API
  1. A query that returns a list of all world leaders, sorted by number of points earned in descending order.
  https://www.grabli.co/api/v1/leaderboard.json

  2. A request that returns a list of leaders for a specific country. The first places will be those who earned the most points.
  https://www.grabli.co/api/v1/leaderboard.json?country=ua

7. Active Admin
  For development environment you can seed admin user with
  `bin/rails db:seed`

  Credentials for PROD admin:

  https://www.grabli.co/admin/login
  login: admin@example.com
  pass: password

8. Data simulation
    1. One-time generation of 150 million users.
    ```ruby
    class PopulateLeaderboard
      def initialize count: 1_000_000
        @count = count
      end

      def call
        ActiveRecord::Base.connection.execute(
          "
            -- Create a function that returns a random string from a fixed array
            CREATE OR REPLACE FUNCTION get_random_country()
            RETURNS text AS $$
            DECLARE
                strings text[] := ARRAY['SY', 'TW', 'TJ', 'TZ', 'TH', 'TL', 'TG', 'TK', 'TO', 'TT', 'TN', 'TR', 'TM', 'TC', 'TV', 'UG', 'UA', 'AE', 'GB'];
            BEGIN
                RETURN strings[1 + floor(random() * array_length(strings, 1))];
            END;
            $$ LANGUAGE plpgsql;

            INSERT INTO users (name, country, score, created_at, updated_at)
            SELECT
                'user_name_' || id,
                (get_random_country()), -- Subquery to fetch a random country code
                floor(random() * (1000000 - 150 + 1) + 150)::integer,  -- Generating a score from 150 to 1,000,000
                now(),
                now()
            FROM generate_series(1, #{@count}) AS id;
          "
        )
      end
    end
    ```

    2. Every second the data is randomly updated.
    Sidekiq Cron Config
    ```yaml
      update_users_score:
        cron: "*/1 * * * *"
        class: "UpdateUsersScoreContainerJob"
        queue: default
    ```
