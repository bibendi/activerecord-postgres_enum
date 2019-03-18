# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActiveRecord::PostgresEnum::CommandRecorder do
  let(:connection) { ActiveRecord::Base.connection }

  it "reverts create_enum" do
    migration = build_migration { create_enum :genre, %w[drama comedy] }

    migration.migrate(:up)

    expect(connection.enums[:genre]).to eq %w[comedy drama]

    migration.migrate(:down)

    expect(connection.enums[:genre]).to be_nil
  end

  it "reverts rename_enum" do
    build_migration { create_enum :genre, %w[drama comedy] }.migrate(:up)

    migration = build_migration { rename_enum :genre, :style }

    migration.migrate(:up)

    expect(connection.enums[:genre]).to be_nil
    expect(connection.enums[:style]).to eq %w[comedy drama]

    migration.migrate(:down)

    expect(connection.enums[:style]).to be_nil
    expect(connection.enums[:genre]).to eq %w[comedy drama]
  end

  it "reverts rename_enum_value" do
    build_migration { create_enum :genre, %w[drama comedy] }.migrate(:up)

    migration = build_migration { rename_enum_value :genre, :drama, :thriller }

    migration.migrate(:up)

    expect(connection.enums[:genre]).to eq %w[comedy thriller]

    migration.migrate(:down)

    expect(connection.enums[:genre]).to eq %w[comedy drama]
  end
end
