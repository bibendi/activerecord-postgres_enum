# frozen_string_literal: true

module MigrationsHelper
  def build_migration(&block)
    Class.new(Rails::VERSION::MAJOR < 5 ? ActiveRecord::Migration : ActiveRecord::Migration::Current) do
      define_method(:change, &block)
    end
  end
end
