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
      connection.create_enum(:foo, %w[a1 a2])
    end

    it "creates an enum" do
      expect(connection.enum_types[:foo]).to eq %w[a1 a2]
    end

    it "creates an enum if not exists" do
      expect { connection.create_enum(:foo, %w[a1 a2], if_not_exists: true) }.not_to raise_error
    end

    it "does not change the enum options if it exists" do
      expect { connection.create_enum(:foo, %w[b1 b2], if_not_exists: true) }.not_to raise_error
      expect(connection.enum_types[:foo]).to eq %w[a1 a2]
    end

    it "fails create an existing enum" do
      expect { connection.create_enum(:foo, %w[a1 a2]) }.to raise_error StandardError
    end

    context "it forces the creation of an enum" do
      it "recreates an enum with current set of values" do
        expect(connection.enum_types[:foo]).to eq %w[a1 a2]
        expect { connection.create_enum(:foo, %w[b1 b2], force: :cascade) }.not_to raise_error
        expect(connection.enum_types[:foo]).to eq %w[b1 b2]
      end

      it "does not error out if forcing creation of an enum" do
        expect(connection.enum_types[:bar]).to be_nil
        expect { connection.create_enum(:bar, %w[a1 a2], force: :cascade) }.not_to raise_error
        expect(connection.enum_types[:bar]).to eq %w[a1 a2]
      end

      context "cascading" do
        before do
          connection.create_table :test_tbl_for_cascade do |t|
            t.enum :baz, enum_type: :foo
          end
        end

        it "fails to force create an enum if not cascading" do
          expect { connection.create_enum(:foo, %w[a1 a2], force: true) }.to raise_error StandardError
        end

        it "force creates an enum if cascading" do
          expect { connection.create_enum(:foo, %w[a1 a2], force: :cascade) }.not_to raise_error
        end
      end
    end

    it "drops an enum" do
      expect { connection.drop_enum(:foo) }.to_not raise_error
      expect(connection.enum_types[:foo]).to be_nil
    end

    it "drops an enum if exists" do
      expect { connection.drop_enum(:some_unknown_type, if_exists: true) }.to_not raise_error
    end

    it "fails drop a non existing enum" do
      expect { connection.drop_enum(:some_unknown_type) }.to raise_error StandardError
    end

    context "drops an enum with cascade" do
      before do
        connection.create_table :test_tbl_for_cascade do |t|
          t.enum :baz, enum_type: :foo
        end
      end

      it "fails drop an enum with cascade" do
        expect { connection.drop_enum(:foo) }.to raise_error StandardError
      end

      it "drops an enum with cascade" do
        expect { connection.drop_enum(:foo, cascade: true) }.to_not raise_error
        expect(connection.columns("test_tbl_for_cascade").map(&:name)).to_not include("baz")
      end
    end

    it "renames an enum" do
      expect { connection.rename_enum(:foo, :bar) }.to_not raise_error
      expect(connection.enum_types[:bar]).to eq %w[a1 a2]
    end

    it "adds an enum value" do
      expect { connection.add_enum_value(:foo, "a3") }.to_not raise_error
      expect(connection.enum_types[:foo]).to eq %w[a1 a2 a3]
    end

    it "adds an enum value if not exists" do
      expect { connection.add_enum_value(:foo, "a1", if_not_exists: true) }.to_not raise_error
    end

    it "fails to add an enum value if exists" do
      expect { connection.add_enum_value(:foo, "a1", if_not_exists: false) }.to raise_error StandardError
      expect { connection.add_enum_value(:foo, "a2") }.to raise_error StandardError
    end

    it "adds an enum value after a given value" do
      expect { connection.add_enum_value(:foo, "a3", after: "a1") }.to_not raise_error
      expect(connection.enum_types[:foo]).to eq %w[a1 a3 a2]
    end

    it "adds an enum value before a given value" do
      expect { connection.add_enum_value(:foo, "a3", before: "a1") }.to_not raise_error
      expect(connection.enum_types[:foo]).to eq %w[a3 a1 a2]
    end

    it "adds an enum value with a space" do
      expect { connection.add_enum_value(:foo, "a 3") }.to_not raise_error
      expect(connection.enum_types[:foo]).to eq ["a1", "a2", "a 3"]
    end

    it "adds an enum value with a comma" do
      expect { connection.add_enum_value(:foo, "a,3") }.to_not raise_error
      expect(connection.enum_types[:foo]).to eq ["a1", "a2", "a,3"]
    end

    it "adds an enum value with a single quote" do
      expect { connection.add_enum_value(:foo, "a'3") }.to_not raise_error
      expect(connection.enum_types[:foo]).to eq ["a1", "a2", "a'3"]
    end

    it "adds an enum value with a double quote" do
      expect { connection.add_enum_value(:foo, 'a"3') }.to_not raise_error
      expect(connection.enum_types[:foo]).to eq ["a1", "a2", 'a"3']
    end

    it "removes an enum value" do
      expect { connection.remove_enum_value(:foo, "a1") }.to_not raise_error
      expect(connection.enum_types[:foo]).to eq %w[a2]
    end

    it "removes an enum value with a space" do
      expect { connection.add_enum_value(:foo, "a 3") }.to_not raise_error
      expect { connection.remove_enum_value(:foo, "a 3") }.to_not raise_error
      expect(connection.enum_types[:foo]).to eq %w[a1 a2]
    end

    it "removes an enum value with a comma" do
      expect { connection.add_enum_value(:foo, "a,3") }.to_not raise_error
      expect { connection.remove_enum_value(:foo, "a,3") }.to_not raise_error
      expect(connection.enum_types[:foo]).to eq %w[a1 a2]
    end

    it "removes an enum value with a single quote" do
      expect { connection.add_enum_value(:foo, "a'3") }.to_not raise_error
      expect { connection.remove_enum_value(:foo, "a'3") }.to_not raise_error
      expect(connection.enum_types[:foo]).to eq %w[a1 a2]
    end

    it "removes an enum value with a double quote" do
      expect { connection.add_enum_value(:foo, "a\"3") }.to_not raise_error
      expect { connection.remove_enum_value(:foo, "a\"3") }.to_not raise_error
      expect(connection.enum_types[:foo]).to eq %w[a1 a2]
    end

    it "renames an enum value" do
      expect { connection.rename_enum_value(:foo, "a2", "b2") }.to_not raise_error
      expect(connection.enum_types[:foo]).to eq %w[a1 b2]
    end

    it "creates table with enum column" do
      expect do
        connection.create_table :albums do |t|
          t.enum :bar, enum_type: :foo
        end
      end.to_not raise_error

      col = connection.columns(:albums).find { |c| c.name == "bar" }
      expect(col).not_to be nil
      expect(col.type).to eq :enum
      expect(col.sql_type).to eq "foo"
    end

    it "adds an enum value to an existing table" do
      expect { connection.add_column(:tracks, :bar, :foo) }.to_not raise_error

      col = connection.columns(:tracks).find { |c| c.name == "bar" }
      expect(col).not_to be nil
      expect(col.type).to eq :enum
      expect(col.sql_type).to eq "foo"
    end
  end
end
