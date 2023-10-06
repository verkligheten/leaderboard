Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL') { "redis://localhost:6379/0" } }

  config.capsule("unsafe") do |cap|
    cap.concurrency = 1
    cap.queues = %w[leaders]
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL') { "redis://localhost:6379/0" } }
end

schedule_file = "config/schedule.yml"
if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
