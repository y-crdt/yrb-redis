# frozen_string_literal: true

module Helpers
  module RedisHelper
    REDIS_CONFIG = {
      url: ENV["REDIS_URL"] || "redis://127.0.0.1:6379/1"
    }.freeze

    def self.included(rspec)
      rspec.around(:each, redis: true) do |example|
        with_clean_redis do
          example.run
        end
      end
    end

    def redis
      @redis ||= ::Redis.new(REDIS_CONFIG)
    end

    def with_clean_redis
      redis.flushall
      begin
        yield
      ensure
        redis.flushall
      end
    end
  end
end
