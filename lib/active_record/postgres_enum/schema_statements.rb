# frozen_string_literal: true

module ActiveRecord
  module PostgresEnum
    module SchemaStatements
      def type_to_sql(type, enum_type: nil, **kwargs)
        if type.to_s == "enum"
          enum_type
        else
          super
        end
      end
    end
  end
end
