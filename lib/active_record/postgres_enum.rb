# frozen_string_literal: true

require "active_record"
require "active_record/schema_dumper"
require "active_record/connection_adapters/postgresql/schema_statements"
require "active_record/connection_adapters/postgresql_adapter"
require "active_support/lazy_load_hooks"

require "active_record/postgres_enum/version"
require "active_record/postgres_enum/postgresql_adapter"
require "active_record/postgres_enum/schema_dumper"
require "active_record/postgres_enum/enum_validator"

ActiveSupport.on_load(:active_record) do
  require "active_record/postgres_enum/extensions"

  ActiveRecord::SchemaDumper.prepend ActiveRecord::PostgresEnum::SchemaDumper
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend ActiveRecord::PostgresEnum::PostgreSQLAdapter

  ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:enum] = {
    name: 'enum'
  }
end
