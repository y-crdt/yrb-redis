# frozen_string_literal: true

require_relative "redis/config"
require_relative "redis/config/abstract_builder"
require_relative "redis/config/option"
require_relative "redis/config/validations"
require_relative "redis/version"

module Y
  # A Y::Redis instance can be used to persist and load a {Y::Doc}
  #
  # @attr_reader [::Redis] client
  # @attr_reader [::Redlock::Client] lock_manager
  #
  # @example Sync local to remote document via store
  #   client = Redis.new
  #   lock_manager = Redlock::Client.new
  #
  #   local = Y::Doc.new
  #   local_text = local.get_text("my text")
  #   local_text << "Hello, World!"
  #
  #   store = Y::Redis.new
  #   store.save("my text", doc.diff)
  #
  #   update = store.load("my text")
  #
  #   remote = Y::Doc
  #   remote.sync(update)
  #   remote_text = remote.get_text("my text")
  #   puts remote_text.to_s # "Hello, World!"
  #
  class Redis
    class Error < StandardError; end

    attr_reader :client, :lock_manager

    # @param [::Redis] client
    # @param [::Redlock::Client] lock_manager
    def initialize(client, lock_manager)
      @client = client
      @lock_manager = lock_manager
    end

    # Save document to store.
    #
    # This method expects a binary encoded update in the form of an Array of
    # Integers.
    #
    # @param [String] id
    # @param [::Array<Integer>] update
    # @return [Boolean] True if lock was acquired and document saved
    def save(id, update)
      lock_manager.lock!("resource_key", 2000) do
        data = encode(update)
        client.set(id, data)
        true
      end
    rescue Redlock::LockError
      false
    end

    # Load document from store
    #
    # @param [String] id
    # @return [::Array<Integer>, nil]
    def load(id)
      data = client.get(id)
      decode(data)
    end

    private

    # Encode a ByteArray into a string
    #
    # @param [::Array<Integer>] update
    # @return [String]
    def encode(update)
      update.pack("C*")
    end

    # Decode a packed string into a ByteArray
    #
    # @param [String] data
    # @return [::Array<Integer>]
    def decode(data)
      data.unpack("C*")
    end
  end
end
