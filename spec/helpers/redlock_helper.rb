# frozen_string_literal: true

module Helpers
  module RedlockHelper
    REDLOCK_CONFIG = { url: ENV["REDIS_URL"] || "redis://127.0.0.1:6379/1" }.freeze

    def lock_manager
      @lock_manager ||= ::Redlock::Client.new([REDLOCK_CONFIG[:url]])
    end
  end
end
