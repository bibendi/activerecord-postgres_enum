# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_enum("moods", %w[happy great been_better])

  create_table :tracks do |t|
    t.enum "mood", enum_name: :moods
  end
end
