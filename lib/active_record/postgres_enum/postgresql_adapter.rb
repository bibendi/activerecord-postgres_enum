# frozen_string_literal: true

module ActiveRecord
  module PostgresEnum
    module PostgreSQLAdapter
      # For Rails >= 5.2
      # https://github.com/rails/rails/blob/5-2-stable/activerecord/lib/active_record/connection_adapters/postgresql/schema_dumper.rb
      module SchemaDumperExt
        def prepare_column_options(column)
          spec = super
          spec[:enum_name] = column.sql_type.inspect if column.type == :enum
          spec
        end
      end

      # For Rails <5.2
      # https://github.com/rails/rails/blob/5-1-stable/activerecord/lib/active_record/connection_adapters/postgresql/schema_dumper.rb
      module ColumnDumperExt
        def prepare_column_options(column)
          spec = super
          spec[:enum_name] = column.sql_type.inspect if column.type == :enum
          spec
        end
      end

      DEFINED_ENUMS_QUERY = <<~SQL
        SELECT
          t.OID,
          t.typname,
          t.typtype,
          array_to_string(array_agg(e.enumlabel ORDER BY e.enumsortorder), '\t\t', '') as enumlabels
        FROM pg_type t
        LEFT JOIN pg_enum e ON e.enumtypid = t.oid
        WHERE typtype = 'e'
        GROUP BY t.OID, t.typname, t.typtype
        ORDER BY t.typname
      SQL

      def enums
        select_all(DEFINED_ENUMS_QUERY).each_with_object({}) do |row, memo|
          memo[row["typname"].to_sym] = row["enumlabels"].split("\t\t")
        end
      end

      def create_enum(name, values, force: false, if_not_exists: nil)
        return if if_not_exists && enums.include?(name.to_sym)

        drop_enum(name, cascade: force == :cascade, if_exists: true) if force

        values = values.map { |v| quote v }
        execute "CREATE TYPE #{name} AS ENUM (#{values.join(", ")})"
      end

      def drop_enum(name, cascade: nil, if_exists: nil)
        if_exists_statement = "IF EXISTS" if if_exists
        cascade_statement = "CASCADE" if cascade

        sql = "DROP TYPE #{if_exists_statement} #{name} #{cascade_statement}"
        execute sql
      end

      def rename_enum(name, new_name)
        execute "ALTER TYPE #{name} RENAME TO #{new_name}"
      end

      def add_enum_value(name, value, after: nil, before: nil, if_not_exists: nil)
        if_not_exists_statement = "IF NOT EXISTS" if if_not_exists

        sql = "ALTER TYPE #{name} ADD VALUE #{if_not_exists_statement} #{quote value}"
        if after
          sql += " AFTER #{quote after}"
        elsif before
          sql += " BEFORE #{quote before}"
        end
        execute sql
      end

      def remove_enum_value(name, value)
        sql = %{
          DELETE FROM pg_enum
          WHERE enumlabel=#{quote value}
          AND enumtypid=(SELECT oid FROM pg_type WHERE typname='#{name}')
        }
        execute sql
      end

      def rename_enum_value(name, existing_value, new_value)
        raise "Renaming enum values is only supported in PostgreSQL 10.0+" unless rename_enum_value_supported?

        execute "ALTER TYPE #{name} RENAME VALUE #{quote existing_value} TO #{quote new_value}"
      end

      def migration_keys
        super + [:enum_name]
      end

      def prepare_column_options(column, types)
        spec = super(column, types)
        spec[:enum_name] = column.cast_type.enum_name.inspect if column.type == :enum
        spec
      end

      def rename_enum_value_supported?
        ActiveRecord::Base.connection.send(:postgresql_version) >= 100_000
      end
    end
  end
end
