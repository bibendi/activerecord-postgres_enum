# frozen_string_literal: true

RSpec.describe ActiveRecord::PostgresEnum do
  it "has a version number" do
    expect(ActiveRecord::PostgresEnum::VERSION).not_to be nil
  end

  it "has created table for tracks from schema.rb" do
    expect(Track.create(mood: "happy")).to be_truthy
  end

  describe "adapter" do
    let(:connection) { ActiveRecord::Base.connection }

    before do
      connection.create_enum(:foo, %w(a1 a2))
    end

    it "creates an enum" do
      expect(connection.enums[:foo]).to eq %w(a1 a2)
    end

    it "drops an enum" do
      expect { connection.drop_enum(:foo) }.to_not raise_error
      expect(connection.enums[:foo]).to be_nil
    end

    it "renames an enum" do
      expect { connection.rename_enum(:foo, :bar) }.to_not raise_error
      expect(connection.enums[:bar]).to eq %w(a1 a2)
    end

    it "adds an enum value" do
      expect { connection.add_enum_value(:foo, "a3") }.to_not raise_error
      expect(connection.enums[:foo]).to eq %w(a1 a2 a3)
    end

    it "renames an enum value" do
      expect { connection.rename_enum_value(:foo, "a2", "b2") }.to_not raise_error
      expect(connection.enums[:foo]).to eq %w(a1 b2)
    end
  end
end
