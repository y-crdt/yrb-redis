# frozen_string_literal: true

require "redlock"
require "y/redis/config/abstract_builder"
require "y/redis/config/option"
require "y/redis/config/validations"

module Y
  class Redis
    class MissingConfiguration < StandardError
      def initialize
        super(
          "Configuration for Y::Redis is missing. Do you have an initializer?")
      end
    end

    class MissingConfigurationBuilderClass < StandardError; end

    class << self
      def configure(&block)
        @config = Config::Builder.new(&block).build
      end

      def configuration
        @config || (raise MissingConfiguration)
      end

      alias config configuration
    end

    # https://github.com/doorkeeper-gem/doorkeeper/blob/main/lib/doorkeeper/config.rb
    class Config
      class Builder < AbstractBuilder
      end

      def self.builder_class
        Builder
      end

      extend Option
      include Validations

      # @attr_reader [::Redis] client
      option :client, default: ->(*_args, **_kwargs) {}

      # @attr_reader [::Redlock::Client] lock_manager
      option :lock_manager, default: lambda {
        location = Y::Redis.client.connection[:location]
        pp "location=#{location}"
        Redlock::Client.new([location])
      }
    end
  end
end
