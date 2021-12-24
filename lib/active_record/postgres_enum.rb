# frozen_string_literal: true

require "active_record"
require "active_record/schema_dumper"
require "active_record/connection_adapters/postgresql/schema_statements"
require "active_record/connection_adapters/postgresql_adapter"
require "active_support/lazy_load_hooks"

module ActiveRecord
  module PostgresEnum
    def self.rails_7?
      ActiveRecord::VERSION::MAJOR == 7
    end

    def self.rails_5?
      ActiveRecord::VERSION::MAJOR == 5
    end
  end
end

require "active_record/postgres_enum/version"
require "active_record/postgres_enum/postgresql_adapter"
require "active_record/postgres_enum/schema_dumper"
require "active_record/postgres_enum/schema_statements"
require "active_record/postgres_enum/column"
require "active_record/postgres_enum/column_methods"
require "active_record/postgres_enum/command_recorder"
require "active_record/postgres_enum/enum_validator"

ActiveSupport.on_load(:active_record) do
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend ActiveRecord::PostgresEnum::PostgreSQLAdapter

  ActiveRecord::ConnectionAdapters::PostgreSQL::SchemaDumper.prepend(
    ActiveRecord::PostgresEnum::SchemaDumper
  )

  ActiveRecord::Migration::CommandRecorder.prepend ActiveRecord::PostgresEnum::CommandRecorder

  unless ActiveRecord::PostgresEnum.rails_7?
    ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:enum] = {}

    if ActiveRecord::PostgresEnum.rails_5?
      ActiveRecord::ConnectionAdapters::PostgreSQLColumn.prepend(
        ActiveRecord::PostgresEnum::Column
      )
    else
      ActiveRecord::ConnectionAdapters::PostgreSQL::Column.prepend(
        ActiveRecord::PostgresEnum::Column
      )
    end

    ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition.include(
      ActiveRecord::PostgresEnum::ColumnMethods
    )

    ActiveRecord::ConnectionAdapters::PostgreSQL::Table.include(
      ActiveRecord::PostgresEnum::ColumnMethods
    )

    ActiveRecord::ConnectionAdapters::PostgreSQL::SchemaStatements.prepend(
      ActiveRecord::PostgresEnum::SchemaStatements
    )
  end
end
