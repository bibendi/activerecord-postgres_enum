# frozen_string_literal: true

module ActiveRecord
  module PostgresEnum
    class EnumValidator < ActiveModel::EachValidator
      def self.enum_values(attr_id, type, connection)
        @enums ||= {}
        return @enums[attr_id] if @enums.key?(attr_id)

        @enums[attr_id] ||= connection.enums.fetch(type.to_sym) do
          raise "Enum `#{type}` not found in a database #{connection}"
        end
      end

      def validate_each(object, attribute, value)
        enum_type = enum_type(object, attribute)
        attr_id = "#{object.class.name}##{attribute}"

        return if self.class.enum_values(attr_id, enum_type, object.class.connection).include?(value)

        object.errors.add(
          attribute,
          options[:message] || :invalid_enum_value,
          value: value,
          type: enum_type
        )
      end

      private

      def enum_type(object, attribute)
        object.class.columns_hash[attribute.to_s].sql_type
      end
    end
  end
end

module ActiveModel
  module Validations
    module HelperMethods
      def validates_enum(*attr_names)
        validates_with ActiveRecord::PostgresEnum::EnumValidator, _merge_attributes(attr_names)
      end
    end
  end
end
