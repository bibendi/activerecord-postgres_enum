# frozen_string_literal: true

module ActiveRecord
  module PostgresEnum
    # provide support for writing out the 'create_enum' calls in schema.rb
    module SchemaDumper
      def tables(stream)
        enums(stream)
        super(stream)
      end

      private

      def defined_enums
        query = <<~SQL
          SELECT t.OID, t.typname, t.typtype, array_agg(e.enumlabel) as enumlabels
          FROM pg_type t
          INNER JOIN pg_enum e ON e.enumtypid = t.oid
          WHERE typtype = 'e'
          GROUP BY t.OID, t.typname, t.typtype
          ORDER BY t.typname
        SQL

        @connection.select_all(query).each do |enum|
          enum['enumlabels'] = enum['enumlabels'].gsub!(/[{}]/, '').split(',')
        end
      end

      def enums(stream)
        statements = []

        defined_enums.each do |enum|
          enum_name = enum['typname']
          values = enum['enumlabels'].map(&:inspect).join(', ')
          statements << "  create_enum(#{enum_name.inspect}, [#{values}])"
        end

        stream.puts statements.join("\n")
        stream.puts
      end
    end
  end
end
