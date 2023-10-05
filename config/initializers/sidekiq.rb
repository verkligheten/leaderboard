Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL') { "redis://localhost:6379/1" } }

  config.capsule("unsafe") do |cap|
    cap.concurrency = 1
    cap.queues = %w[leaders]
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL') { "redis://localhost:6379/1" } }
end
