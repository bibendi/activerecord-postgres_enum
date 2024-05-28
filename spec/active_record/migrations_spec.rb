# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActiveRecord::PostgresEnum::CommandRecorder do
  let(:connection) { ActiveRecord::Base.connection }

  it "reverts create_enum with no options" do
    migration = build_migration { create_enum :genre, %w[drama comedy] }

    migration.migrate(:up)

    expect(connection.enum_types[:genre]).to eq %w[drama comedy]

    migration.migrate(:down)

    expect(connection.enum_types[:genre]).to be_nil
  end

  it "reverts create_enum with options" do
    migration = build_migration { create_enum :genre, %w[drama comedy], force: true, if_not_exists: true }

    migration.migrate(:up)

    expect(connection.enum_types[:genre]).to eq %w[drama comedy]

    migration.migrate(:down)

    expect(connection.enum_types[:genre]).to be_nil
  end

  it "reverts rename_enum" do
    build_migration { create_enum :genre, %w[drama comedy] }.migrate(:up)

    migration = build_migration { rename_enum :genre, :style }

    migration.migrate(:up)

    expect(connection.enum_types[:genre]).to be_nil
    expect(connection.enum_types[:style]).to eq %w[drama comedy]

    migration.migrate(:down)

    expect(connection.enum_types[:style]).to be_nil
    expect(connection.enum_types[:genre]).to eq %w[drama comedy]
  end

  it "reverts rename_enum_value" do
    build_migration { create_enum :genre, %w[drama comedy] }.migrate(:up)

    migration = build_migration { rename_enum_value :genre, :drama, :thriller }

    migration.migrate(:up)

    expect(connection.enum_types[:genre]).to eq %w[thriller comedy]

    migration.migrate(:down)

    expect(connection.enum_types[:genre]).to eq %w[drama comedy]
  end

  it "reverts add_column" do
    build_migration { create_enum :genre, %w[drama comedy] }.migrate(:up)

    migration = build_migration { add_column :tracks, :genre, :genre }

    migration.migrate(:up)

    col = connection.columns(:tracks).find { |c| c.name == "genre" }
    expect(col).not_to be nil
    expect(col.sql_type).to eq "genre"

    migration.migrate(:down)

    col = connection.columns(:tracks).find { |c| c.name == "genre" }
    expect(col).to be nil
  end
end
