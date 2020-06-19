# frozen_string_literal: true

module ActiveRecord
  module PostgresEnum
    module CommandRecorder
      def create_enum(name, values)
        record(:create_enum, [name, values])
      end

      def invert_create_enum(args)
        [:drop_enum, args.first]
      end

      def rename_enum(name, new_name)
        record(:rename_enum, [name, new_name])
      end

      def invert_rename_enum(args)
        [:rename_enum, args.reverse]
      end

      def rename_enum_value(name, existing_value, new_value)
        record(:rename_enum_value, [name, existing_value, new_value])
      end

      def invert_rename_enum_value(args)
        [:rename_enum_value, [args.first] + args.last(2).reverse]
      end
    end
  end
end
