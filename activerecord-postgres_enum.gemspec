# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_record/postgres_enum/version"

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name = "activerecord-postgres_enum"
  spec.version = ActiveRecord::PostgresEnum::VERSION
  spec.authors = ["Michael Merkushin"]
  spec.email = ["merkushin.m.s@gmail.com"]

  spec.summary = "Integrate PostgreSQL's enum data type into ActiveRecord's schema and migrations."
  spec.homepage = "https://github.com/bibendi/activerecord-postgres_enum"
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob("lib/**/*") + %w[LICENSE.txt README.md]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.5"

  spec.add_runtime_dependency "activerecord", ">= 5"
  spec.add_runtime_dependency "pg"

  spec.add_development_dependency "appraisal", "~> 2.2"
  spec.add_development_dependency "bundler", ">= 1.16"
  spec.add_development_dependency "combustion", "~> 1.1"
  spec.add_development_dependency "pry-byebug", "~> 3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec-rails", "~> 5.0"
  spec.add_development_dependency "standard", "~> 1.1"
end
# rubocop:enable Metrics/BlockLength
