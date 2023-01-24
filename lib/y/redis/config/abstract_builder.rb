# frozen_string_literal: true

module Y
  class Redis
    class Config
      # Abstract base class for Y::Redis and it's extensions configuration
      # builder. Instantiates and validates gem configuration.
      #
      class AbstractBuilder
        attr_reader :config

        # @param [Y::Redis::Config] config class
        def initialize(config = Config.new, &block)
          @config = config
          instance_eval(&block)
        end

        # Builds and validates configuration.
        #
        # @return [Y::Redis::Config] config instance
        def build
          @config.validate! if @config.respond_to?(:validate!)
          @config
        end
      end
    end
  end
end
