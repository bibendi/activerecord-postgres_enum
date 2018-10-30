# frozen_string_literal: true

module ActiveRecord
  module PostgresEnum
    module PostgreSQLAdapter
      def create_enum(name, values)
        values = values.map { |v| "'#{v}'" }
        execute "CREATE TYPE #{name} AS ENUM (#{values.join(', ')})"
      end

      def drop_enum(name)
        execute "DROP TYPE #{name}"
      end

      def alter_enum(name, value)
        execute "ALTER TYPE #{name} ADD VALUE '#{value}'"
      end

      def migration_keys
        super + [:enum_name]
      end

      def prepare_column_options(column, types)
        spec = super(column, types)
        spec[:enum_name] = column.cast_type.enum_name.inspect if column.type == :enum
        spec
      end
    end
  end
end
