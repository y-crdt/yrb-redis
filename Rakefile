# frozen_string_literal: true

begin
  require "rspec/core"
  require "rspec/core/rake_task"

  desc "Run specs"
  RSpec::Core::RakeTask.new(:spec)

  task test: :spec
  task default: %i[test]
rescue LoadError
  # Ok
end

begin
  require "rubocop/rake_task"

  RuboCop::RakeTask.new
rescue LoadError
  # Ok
end

begin
  require "yard"

  YARD::Rake::YardocTask.new

  task :docs do
    `yard server --reload`
  end
rescue LoadError
  # Ok
end
