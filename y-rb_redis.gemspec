# frozen_string_literal: true

require_relative "lib/y/redis/version"

Gem::Specification.new do |spec|
  spec.name        = "y-rb_redis"
  spec.version     = Y::Redis::VERSION
  spec.authors     = ["Hannes Moser"]
  spec.email       = ["box@hannesmoser.at"]
  spec.summary     = "A Redis companion for y-rb."
  spec.description = "A Redis companion for y-rb."
  spec.homepage    = "https://github.com/y-crdt/yrb-actioncable"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/y-crdt/yrb-redis"
  spec.metadata["changelog_uri"] = "https://y-crdt.github.io/yrb-redis/"

  spec.files = Dir["{lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  spec.require_paths = ["lib"]

  spec.add_dependency "redlock", ">= 1.3.2"

  spec.metadata["rubygems_mfa_required"] = "true"
end
