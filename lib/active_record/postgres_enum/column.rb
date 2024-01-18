# frozen_string_literal: true

module ActiveRecord
  module PostgresEnum
    module Column
      def enum?
        type == :enum
      end
    end
  end
end
