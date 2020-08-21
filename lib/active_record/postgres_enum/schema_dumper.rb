# frozen_string_literal: true

module ActiveRecord
  module PostgresEnum
    # provide support for writing out the 'create_enum' calls in schema.rb
    module SchemaDumper
      def tables(stream)
        dump_enums(stream)

        super
      end

      private

      def dump_enums(stream)
        statements = []

        @connection.enums.each do |name, values|
          values = values.map { |v| "    #{v.inspect}," }.join("\n")
          statements << "  create_enum #{name.inspect}, [\n#{values}\n  ], force: :cascade"
        end

        stream.puts statements.join("\n\n")
        stream.puts
      end
    end
  end
end
