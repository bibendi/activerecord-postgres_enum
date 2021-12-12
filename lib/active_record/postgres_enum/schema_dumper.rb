# frozen_string_literal: true

module ActiveRecord
  module PostgresEnum
    # provide support for writing out the 'create_enum' calls in schema.rb
    module SchemaDumper
      def tables(stream)
        types(stream)

        super
      end

      private

      def types(stream)
        statements = []
        if @connection.respond_to?(:enum_types)
          @connection.enum_types.each do |name, values|
            values = values.map { |v| "    #{v.inspect}," }.join("\n")
            statements << "  create_enum #{name.inspect}, [\n#{values}\n  ], force: :cascade"
          end

          stream.puts statements.join("\n\n")
          stream.puts
        end
      end

      def prepare_column_options(column)
        spec = super
        spec[:enum_type] ||= "\"#{column.sql_type}\"" if column.enum?
        spec
      end
    end
  end
end
