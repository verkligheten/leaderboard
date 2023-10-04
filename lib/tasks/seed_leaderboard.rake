namespace :seed do
  # rake 'seed:leaderboard[300]'
  desc 'Populate Leaderboard with users'
  task :leaderboard, [:count] => :environment do |_t, args|
    count = args[:count]&.to_i || 1_000_000

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
        FROM generate_series(1, #{count}) AS id;
      "
    )

  end
end
