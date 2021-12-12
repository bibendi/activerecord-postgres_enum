# frozen_string_literal: true

module ActiveRecord
  module PostgresEnum
    module ColumnMethods
      # Enables `t.enum :my_field, enum_type: :my_enum_name` on migrations
      def enum(name, enum_type:, **options)
        column(name, enum_type, **options)
      end
    end
  end
end
