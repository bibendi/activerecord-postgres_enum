# frozen_string_literal: true

RSpec.describe ActiveRecord::PostgresEnum do
  it "has a version number" do
    expect(ActiveRecord::PostgresEnum::VERSION).not_to be nil
  end
end
