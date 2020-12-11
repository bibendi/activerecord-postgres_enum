# frozen_string_literal: true

module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module OID # :nodoc:
        class Enum < Type::Value # :nodoc:
          attr_reader :enum_name

          def initialize(enum_name:, **kwargs)
            @enum_name = enum_name.to_sym
            super(**kwargs)
          end
        end

        class TypeMapInitializer
          # We need to know the column name, and the default implementation discards it
          def register_enum_type(row)
            register row["oid"], OID::Enum.new(enum_name: row["typname"])
          end
        end
      end

      module ColumnMethods # :nodoc:
        # Enables `t.enum :my_field, enum_name: :my_enum_name` on migrations
        def enum(name, options = {})
          column(name, options.delete(:enum_name), options.except(:enum_name))
        end
      end
    end
  end
end
