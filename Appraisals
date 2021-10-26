# frozen_string_literal: true

if RUBY_VERSION < "3"
  appraise "rails-5" do
    gem "rails", "~> 5.0"
  end
end

appraise "rails-6" do
  gem "rails", "~> 6.0"
end

if RUBY_VERSION >= "2.7"
  appraise "rails-7" do
    gem "rails", "~> 7.0.0.alpha2"
  end
end
