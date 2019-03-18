# frozen_string_literal: true

require "bundler/setup"
require "activerecord/postgres_enum"
require "pry-byebug"

require "combustion"
Combustion.initialize! :active_record

require "rspec/rails"
require "support/migrations_helper"

RSpec.configure do |config|
  config.include MigrationsHelper

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.use_transactional_fixtures = true
end
